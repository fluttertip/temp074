import 'package:flutter/material.dart';
import 'package:homeservice/models/hardcoded_option_services_model.dart';
import 'package:homeservice/models/service_model.dart';

class EditServiceFormProvider extends ChangeNotifier {
  final String serviceId;
  final TextEditingController titleController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;

  String? selectedCategory;
  ServiceSubcategory? selectedSubcategory;
  bool isLoading = false;

  final LayerLink layerLink = LayerLink();
  OverlayEntry? _suggestionOverlay;

  EditServiceFormProvider({
    required this.serviceId,
    required this.titleController,
    required this.priceController,
    required this.descriptionController,
    required this.selectedCategory,
  });

  factory EditServiceFormProvider.fromService(ServiceModel service) {
    return EditServiceFormProvider(
      serviceId: service.id,
      titleController: TextEditingController(text: service.title),
      priceController: TextEditingController(
        text: service.price.toStringAsFixed(2),
      ),
      descriptionController: TextEditingController(text: service.description),
      selectedCategory: service.category,
    );
  }

  String get selectedImage =>
      selectedSubcategory?.imageUrl ??
      "https://dummyimage.com/600x400/000/fff?text=Service";

  bool get isValid =>
      selectedCategory != null &&
      titleController.text.trim().isNotEmpty &&
      priceController.text.trim().isNotEmpty &&
      double.tryParse(priceController.text.trim()) != null &&
      double.parse(priceController.text.trim()) > 0 &&
      descriptionController.text.trim().isNotEmpty;

  void setCategory(String? category) {
    selectedCategory = category;
    selectedSubcategory = null;
    notifyListeners();
  }

  void setSubcategory(ServiceSubcategory? subcategory) {
    selectedSubcategory = subcategory;
    if (subcategory != null) {
      titleController.text = subcategory.name;
    }
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void onFieldChanged() {
    notifyListeners();
  }

  void showSuggestions(
    BuildContext context,
    List<ServiceSubcategory> subcategories,
  ) {
    _removeOverlay();

    final input = titleController.text.trim().toLowerCase();
    if (input.isEmpty) return;

    final matches = subcategories
        .where((s) => s.name.toLowerCase().contains(input))
        .toList();

    if (matches.isEmpty) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _suggestionOverlay = OverlayEntry(
      builder: (_) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height + 8,
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: matches.length,
              itemBuilder: (_, index) {
                final suggestion = matches[index];
                return ListTile(
                  title: Text(suggestion.name),
                  subtitle: Text(suggestion.description),
                  onTap: () {
                    setSubcategory(suggestion);
                    _removeOverlay();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(_suggestionOverlay!);
  }

  void _removeOverlay() {
    _suggestionOverlay?.remove();
    _suggestionOverlay = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    titleController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
