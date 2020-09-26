import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

const FUNCTIONS_REGION = "europe-west1";

const deleteCollection = async (collection: string) =>
{
    const snapshot = await db.collection(collection).limit(500).get();

    if (snapshot.size === 0) return;

    const batch = db.batch();

    snapshot.docs.forEach((doc) => batch.delete(doc.ref));

    await batch.commit();

    // Recurse on the next process tick, to avoid exploding the stack.
    process.nextTick(() => deleteCollection(collection));
}

const getCircolare = async (id: string): Promise<Circolare> =>
    (await db.collection("circolari").doc(id).get()).data() as Circolare;

const getAnswer = async (circolareId: string, answerId: string): Promise<Answer> =>
    (await db.collection(`circolari/${circolareId}/answers`).doc(answerId).get()).data() as Answer;

export const deleteCircolare = functions.region(FUNCTIONS_REGION).https.onCall(async (data, context) =>
{
    if (!context.auth || !data.id) return;

    const id: string = data.id;

    const circolare: Circolare = await getCircolare(id);

    if (circolare.metadata.owner != context.auth.uid) return;

    await db.collection("circolare").doc(id).delete();

    await deleteCollection(`circolari/${id}/answers`);
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