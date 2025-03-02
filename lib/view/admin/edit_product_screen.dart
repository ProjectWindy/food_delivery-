import 'package:flutter/material.dart';
import 'package:food_delivery/models/food.dart';
import 'package:food_delivery/view/admin/image.dart';
 
import '../../services/service_call.dart';

class EditProductScreen extends StatefulWidget {
  final ProductModel product;
  final String documentId;

  const EditProductScreen({
    Key? key,
    required this.product,
    required this.documentId,
  }) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  late String id;

  late String name;
  late String foodType;
  late String image;
  late String rate;
  late String rating;
  late String type;

  final List<String> foodTypeOptions = [
    'Desserts',
    'Main Course',
    'Drinks',
    'Appetizers'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize form fields with the product data
    id = widget.documentId;
    name = widget.product.name;
    foodType = widget.product.foodType;
    image = widget.product.image;
    rate = widget.product.rate;
    rating = widget.product.rating;
    type = widget.product.type;
  }

  void _showToast(String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(labelText: 'Product Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Food Type'),
                      value: foodType.isEmpty ? null : foodType,
                      hint: Text('Select food type'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select food type';
                        }
                        return null;
                      },
                      items: foodTypeOptions.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          foodType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    AssetImageSelector(
                      initialImage: image,
                      onImageSelected: (selectedImage) {
                        setState(() {
                          image = selectedImage;
                        });
                      },
                    ),
                    if (image.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Selected image path: $image',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: rate,
                      decoration:
                          InputDecoration(labelText: 'Price (e.g., 4.9)'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Price must be a number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          rate = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: rating,
                      decoration: InputDecoration(labelText: 'Rating Count'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter rating count';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Rating count must be a whole number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          rating = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: type,
                      decoration: InputDecoration(
                          labelText: 'Type (e.g., Cakes by Tella)'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter type';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _updateProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _updateProduct() {
    if (_formKey.currentState!.validate() && image.isNotEmpty) {
      ProductModel updatedProduct = ProductModel(
        id: id,
        name: name,
        foodType: foodType,
        image: image,
        rate: rate,
        rating: rating,
        type: type,
      );

      firestoreService
          .updateProduct(widget.documentId, updatedProduct)
          .then((_) {
        _showToast('Product updated successfully', true);
        Navigator.pop(context, true);
      }).catchError((error) {
        _showToast('Error: Unable to update product', false);
      });
    } else if (image.isEmpty) {
      _showToast('Please select an image for the product', false);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content:
              Text("Are you sure you want to delete '${widget.product.name}'?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Delete",
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct() {
    if (widget.documentId.isEmpty) {
      _showToast('Error: Invalid product ID', false);
      return;
    }

    firestoreService.deleteProduct(widget.documentId).then((_) {
      _showToast('Product deleted successfully', true);
      Navigator.pop(context, true);
    }).catchError((error) {
      _showToast('Error: Unable to delete product', false);
    });
  }
}
