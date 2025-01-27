import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

const FUNCTIONS_REGION = "europe-west1";

const deleteQuery = async (query: FirebaseFirestore.Query) =>
{
    const snapshot = await query.limit(500).get();

    if (snapshot.empty) return;

    const batch = db.batch();

    snapshot.docs.forEach((doc) => batch.delete(doc.ref));

    await batch.commit();

    // Recurse on the next process tick, to avoid exploding the stack.
    process.nextTick(() => deleteQuery(query));
}

const getCircolare = async (id: string): Promise<Circolare> =>
    (await db.collection("circolari").doc(id).get()).data() as Circolare;

const getAnswer = async (circolareId: string, answerId: string): Promise<Answer> =>
    (await db.collection(`circolari/${circolareId}/answers`).doc(answerId).get()).data() as Answer;

export const deleteUser = functions.region(FUNCTIONS_REGION).auth.user().onDelete(async (user) =>
{
    await deleteQuery(db.collection(`circolari`).where("metadata.owner", "==", user.uid));
});

export const deleteCircolare = functions.region(FUNCTIONS_REGION).https.onCall(async (data, context) =>
{
    if (!context.auth || !data.id) return;

    const id: string = data.id;

    const circolare: Circolare = await getCircolare(id);

    if (circolare.metadata.owner != context.auth.uid) return;

    await db.collection("circolari").doc(id).delete();
});

export const deleteCircolareFirestore = functions.region(FUNCTIONS_REGION).firestore.document("circolari/{circolareId}").onDelete(async (snapshot, context) =>
{
    await deleteQuery(db.collection(`circolari/${context.params.circolareId}/answers`));
});

export const validateAnswer = functions.region(FUNCTIONS_REGION).firestore.document("circolari/{circolareId}/answers/{answerId}").onCreate(async (snapshot, context) =>
{
    const circolareId: string = context.params.circolareId;
    const answerId: string = context.params.answerId;

    const circolare: Circolare = await getCircolare(circolareId);

    const answer: Answer = await getAnswer(circolareId, answerId);

    let isValid = true;

    circolare.fields.forEach(field =>
    {
        const answeredField = answer.fields.find((answerField) => answerField.label == field.label);

        if (!answeredField || (answeredField.value == "" && field.isRequired))
        {
            isValid = false;

            return;
        }

        if (answeredField.value == "" && !field.isRequired) return;

        if (field.type == "string" && typeof answeredField.value != "string") isValid = false;
        else if (field.type == "int" && !Number.isInteger(answeredField.value)) isValid = false;
        else if (field.type == "double" && typeof answeredField.value != "number") isValid = false;
        else if (field.type == "bool" && typeof answeredField.value != "boolean") isValid = false;
    });

    if (!isValid) await snapshot.ref.delete();
});

interface Circolare
{
    title: string,

    description: string,

    fields: {
        label: string,
        type: "string" | "int" | "double" | "bool",
        defaultValue: any,
        isRequired: boolean,
    }[],

    settings?: {
        acceptNewAnswers?: boolean,
    },

    metadata: {
        owner: string,
        createdAt: FirebaseFirestore.Timestamp,
    },
}

interface Answer
{
    fields: {
        label: string,
        value: any,
    }[],

    metadata: {
        sent: FirebaseFirestore.Timestamp,
    },
}