import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
cred = credentials.ApplicationDefault()
firebase_admin.initialize_app(cred, {
  'recipefinder-7f50a': project_id,
})

db = firestore.client()

users_ref = db.collection(u'myRecipes')
docs = users_ref.stream()

for doc in docs:
    print(f"{doc.id} => {doc.to_dict()}")