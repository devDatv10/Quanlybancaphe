import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quan_ly_ban_ca_phe/models/categories.dart';
import 'package:quan_ly_ban_ca_phe/themes/theme.dart';

class DeleteCategoryPage extends StatefulWidget {
  static const String routeName = '/delete_category_page';

  const DeleteCategoryPage({Key? key}) : super(key: key);

  @override
  State<DeleteCategoryPage> createState() => _DeleteCategoryPageState();
}

class _DeleteCategoryPageState extends State<DeleteCategoryPage> {
  List<Categories> categories = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('Danh mục').get();
      setState(() {
        categories = querySnapshot.docs
            .map((doc) => Categories.fromDocument(doc))
            .toList();
      });
    } catch (e) {
      print('Error getting categories: $e');
    }
  }

  Future<void> deleteCategory(Categories categoryToDelete) async {
    try {
      // Remove category from the list locally
      setState(() {
        categories.remove(categoryToDelete);
      });

      // Find the document by its id
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Danh mục')
          .where('id', isEqualTo: categoryToDelete.id)
          .get();

      // Delete the document
      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('Danh mục')
            .doc(doc.id)
            .delete();
      }

      print('Category deleted successfully');
      _showAlert('Thông báo', 'Xóa danh mục thành công');
    } catch (e) {
      print('Error deleting category: $e');
      _showAlert('Thông báo', 'Xóa danh mục thất bại, vui lòng thử lại.');
    }
  }

  void _showConfirmDelete(Categories categoryToDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Thông báo', style: GoogleFonts.roboto(color: Colors.blue)),
          content: Text("Bạn có chắc muốn xóa danh mục này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Hủy", style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                deleteCategory(categoryToDelete);
                Navigator.pop(context);
              },
              child: Text("Đồng ý", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: GoogleFonts.roboto(color: Colors.blue),
          ),
          content: Text(content),
          actions: [
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Danh sách danh mục',
                  style: GoogleFonts.arsenal(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ...categories.map((category) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name,
                                style: GoogleFonts.arsenal(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                category.description,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: red,
                            ),
                            onPressed: () {
                              _showConfirmDelete(category);
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
