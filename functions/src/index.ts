import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();

const FUNCTIONS_REGION = "europe-west1"

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

export const deleteCircolare = functions.region(FUNCTIONS_REGION).https.onCall(async (data, context) =>
{
    if (!context.auth || !data.id) return;

    const id: string = data.id;

    const doc = await db.collection("circolari").doc(id).get();

    if ((doc.data() as FirebaseFirestore.DocumentData).metadata.owner != context.auth.uid) return;

    await doc.ref.delete();

    await deleteCollection(`circolari/${id}/answers`);
});

export const validateAnswer = functions.region(FUNCTIONS_REGION).firestore.document("circolari/{circolareId}/answers/{answerId}").onCreate(async (snapshot, context) =>
{
    // TODO
});