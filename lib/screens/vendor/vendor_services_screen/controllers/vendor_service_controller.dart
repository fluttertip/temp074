import 'package:flutter/material.dart';

class VendorServiceController {
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedSubcategory;
  String? selectedImageUrl;
  String? selectedSubcategoryId;

  bool get isFormValid {
    return selectedCategory != null &&
        selectedSubcategory != null &&
        priceController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  void clearInputs() {
    priceController.clear();
    descriptionController.clear();
    selectedCategory = null;
    selectedSubcategory = null;
    selectedImageUrl = null;
    selectedSubcategoryId = null;
  }

  void setCategory(String category) {
    selectedCategory = category;
    selectedSubcategory = null;
    selectedImageUrl = null;
    selectedSubcategoryId = null;
  }

  void setSubcategory(
    String subcategory,
    String imageUrl,
    String subcategoryId,
  ) {
    selectedSubcategory = subcategory;
    selectedImageUrl = imageUrl;
    selectedSubcategoryId = subcategoryId;
  }

  void dispose() {
    priceController.dispose();
    descriptionController.dispose();
  }
}
