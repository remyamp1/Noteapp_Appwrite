import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

class AppwriteService {
  late Client client;
  late Databases databases;

  static const endpoint = "https://cloud.appwrite.io/v1";
  static const projectId = "673adf16001993f00f27";
  static const databaseId = "673adfc6003ad610e644";
  static const collectionId = "673adfe500322c73ac0d";

  AppwriteService() {
    client = Client();
    client.setEndpoint(endpoint);
    client.setProject(projectId);
    databases = Databases(client);
  }

  Future<List<Document>> getTasks() async {
    try {
      final result = await databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );
      return result.documents;
    } catch (e) {
      print("error loading tasks:$e");
      rethrow;
    }
  }

  Future<Document> addNote(String title,String subtitle,String Category,String data) async {
    try {
      final documentId = ID.unique();
      final result = await databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        data: {
          'title': title,
          'subtitle': subtitle,
          'category':Category,
          'date':data,
        },
        documentId: documentId,
      );
      return result;
    } catch (e) {
      print('Error creating task:$e');
      rethrow;
    }
  }



  Future<void> deleteTask(String documentId) async {
    try {
      await databases.deleteDocument(
          databaseId: databaseId,
          collectionId: collectionId,
          documentId: documentId);
    } catch (e) {
      print("error deleting task:$e");
      rethrow;
    }
  }
}
