// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';

// class CompleteServiceSeeder {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Map<String, dynamic> parsePriceRange(String priceRange) {
//     final regex = RegExp(r'NPR\s*([\d,]+)\s*-\s*([\d,]+)');
//     final match = regex.firstMatch(priceRange);

//     if (match != null) {
//       final minPrice = int.parse(match.group(1)!.replaceAll(',', ''));
//       final maxPrice = int.parse(match.group(2)!.replaceAll(',', ''));
//       final basePrice = ((minPrice + maxPrice) / 2).round();

//       return {
//         'minPrice': minPrice,
//         'maxPrice': maxPrice,
//         'basePrice': basePrice,
//         'currency': 'NPR',
//       };
//     }

//     return {
//       'minPrice': 500,
//       'maxPrice': 5000,
//       'basePrice': 2750,
//       'currency': 'NPR',
//     };
//   }

//   String generateImageUrl(String serviceName, String category) {
//     final encodedService = Uri.encodeComponent(serviceName);
//     final encodedCategory = Uri.encodeComponent(category);
//     return "https://dummyimage.com/600x400/4A90E2/FFFFFF?text=$encodedCategory+-+$encodedService";
//   }

//   List<String> generateCategoryImages(String categoryName) {
//     final encodedCategory = Uri.encodeComponent(categoryName);
//     return [
//       "https://dummyimage.com/800x600/4A90E2/FFFFFF?text=$encodedCategory-Hero",
//       "https://dummyimage.com/600x400/5CB85C/FFFFFF?text=$encodedCategory-Service1",
//       "https://dummyimage.com/600x400/F0AD4E/FFFFFF?text=$encodedCategory-Service2",
//       "https://dummyimage.com/600x400/D9534F/FFFFFF?text=$encodedCategory-Service3",
//     ];
//   }

//   List<String> parseKeywords(String keywordString) {
//     return keywordString.split(',').map((e) => e.trim()).toList();
//   }

//   final List<Map<String, dynamic>> allServices = [
//     {
//       "Category": "Adult & Elderly Care",
//       "Subcategory": "General",
//       "Service Name": "Elderly Companion Service",
//       "Suggested Tags": "Elderly, Care, Companion",
//       "Short Description":
//           "Companionship and assistance for elderly people with daily activities.",
//       "Estimated Price Range": "NPR 1,500 - 7,000",
//       "Service Duration": "Per shift",
//     },
//     {
//       "Category": "Adult & Elderly Care",
//       "Subcategory": "General",
//       "Service Name": "Dementia Care Support",
//       "Suggested Tags": "Elderly, Dementia, Support",
//       "Short Description":
//           "Specialized care for dementia and Alzheimer's patients at home.",
//       "Estimated Price Range": "NPR 1,500 - 7,000",
//       "Service Duration": "Per shift",
//     },
//     {
//       "Category": "Agriculture & Rural Support",
//       "Subcategory": "General",
//       "Service Name": "Farm Equipment Rental",
//       "Suggested Tags": "Farming, Tractor, Equipment",
//       "Short Description":
//           "Rental services for agricultural tools and machinery.",
//       "Estimated Price Range": "NPR 2,000 - 10,000",
//       "Service Duration": "Per day",
//     },
//     {
//       "Category": "Agriculture & Rural Support",
//       "Subcategory": "General",
//       "Service Name": "Veterinary Home Visit",
//       "Suggested Tags": "Animal, Vet, Health",
//       "Short Description":
//           "Veterinary professionals providing home visits for livestock and pets.",
//       "Estimated Price Range": "NPR 2,000 - 10,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Water Backflow Issue",
//       "Suggested Tags": "Issue, Backflow, Water",
//       "Short Description":
//           "Professional water backflow issue service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Bathroom Fixture Replacement",
//       "Suggested Tags": "Bathroom, Replacement, Fixture",
//       "Short Description":
//           "Professional bathroom fixture replacement service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Water Purifier/RO Connection",
//       "Suggested Tags": "Purifier, Connection, Water",
//       "Short Description":
//           "Professional water purifier/ro connection service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Water Purifier Plumbing",
//       "Suggested Tags": "Purifier, Plumbing, Water",
//       "Short Description":
//           "Professional water purifier plumbing service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Fuse Replacement",
//       "Suggested Tags": "Replacement, Fuse",
//       "Short Description": "Professional fuse replacement service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Refrigerator Installation",
//       "Suggested Tags": "Refrigerator, Installation",
//       "Short Description":
//           "Professional refrigerator installation service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Microwave Oven Installation",
//       "Suggested Tags": "Oven, Installation, Microwave",
//       "Short Description":
//           "Professional microwave oven installation service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Television (TV) Wall Mounting",
//       "Suggested Tags": "Wall, Television, Mounting, (TV)",
//       "Short Description":
//           "Professional television (tv) wall mounting service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Washing Machine Repair",
//       "Suggested Tags": "Washing, Machine, Repair",
//       "Short Description":
//           "Professional washing machine repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Refrigerator Repair",
//       "Suggested Tags": "Repair, Refrigerator",
//       "Short Description":
//           "Professional refrigerator repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Microwave Oven Repair",
//       "Suggested Tags": "Oven, Repair, Microwave",
//       "Short Description":
//           "Professional microwave oven repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "AC Repair & Gas Refilling",
//       "Suggested Tags": "Gas, Repair, Refilling",
//       "Short Description":
//           "Professional ac repair & gas refilling service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "TV Repair",
//       "Suggested Tags": "Repair",
//       "Short Description": "Professional tv repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Water Purifier Repair",
//       "Suggested Tags": "Purifier, Repair, Water",
//       "Short Description":
//           "Professional water purifier repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "AC Deep Cleaning Service",
//       "Suggested Tags": "Deep, Service, Cleaning",
//       "Short Description":
//           "Professional ac deep cleaning service service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Washing Machine Drum Cleaning",
//       "Suggested Tags": "Cleaning, Washing, Machine, Drum",
//       "Short Description":
//           "Professional washing machine drum cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Water Purifier Filter Cleaning",
//       "Suggested Tags": "Filter, Purifier, Water, Cleaning",
//       "Short Description":
//           "Professional water purifier filter cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Microwave/Oven Internal Cleaning",
//       "Suggested Tags": "Cleaning, Oven, Internal, Microwave",
//       "Short Description":
//           "Professional microwave/oven internal cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "AC Cooling Diagnosis",
//       "Suggested Tags": "Cooling, Diagnosis",
//       "Short Description":
//           "Professional ac cooling diagnosis service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Urgent Refrigerator Cooling Issue",
//       "Suggested Tags": "Urgent, Issue, Refrigerator, Cooling",
//       "Short Description":
//           "Professional urgent refrigerator cooling issue service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Refrigerator",
//       "Service Name": "Smart Fridge WiFi/Touch Panel Setup",
//       "Suggested Tags": "Panel, Fridge, Touch, Smart, Setup, WiFi",
//       "Short Description":
//           "Professional smart fridge wifi/touch panel setup service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Vacuum Cleaner Repair",
//       "Suggested Tags": "Cleaner, Repair, Vacuum",
//       "Short Description":
//           "Professional vacuum cleaner repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Refrigerator",
//       "Service Name": "Fridge Deodorizer Installation",
//       "Suggested Tags": "Deodorizer, Fridge, Installation",
//       "Short Description":
//           "Professional fridge deodorizer installation service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Annual Maintenance Package",
//       "Suggested Tags": "Annual, Maintenance, Package",
//       "Short Description":
//           "Professional annual maintenance package service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Refrigerator Internal Cleaning",
//       "Suggested Tags": "Internal, Refrigerator, Cleaning",
//       "Short Description":
//           "Professional refrigerator internal cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Microwave/Oven Deep Cleaning",
//       "Suggested Tags": "Cleaning, Oven, Deep, Microwave",
//       "Short Description":
//           "Professional microwave/oven deep cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Water Purifier External Cleaning",
//       "Suggested Tags": "Purifier, External, Water, Cleaning",
//       "Short Description":
//           "Professional water purifier external cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Mirror & Glass Surface Cleaning",
//       "Suggested Tags": "Glass, Mirror, Surface, Cleaning",
//       "Short Description":
//           "Professional mirror & glass surface cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Sofa Shampooing & Vacuuming",
//       "Suggested Tags": "Sofa, Shampooing, Vacuuming",
//       "Short Description":
//           "Professional sofa shampooing & vacuuming service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Glass Facade/Window Cleaning",
//       "Suggested Tags": "Cleaning, Glass, Window, Facade",
//       "Short Description":
//           "Professional glass facade/window cleaning service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "Cockroach Control Treatment",
//       "Suggested Tags": "Treatment, Control, Cockroach",
//       "Short Description":
//           "Professional cockroach control treatment service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "Air Conditioning",
//       "Service Name": "AC Gas Refill and Repair",
//       "Suggested Tags": "Repair, Gas, and, Refill",
//       "Short Description":
//           "Professional ac gas refill and repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Electric Kettle or Toaster Repair",
//       "Suggested Tags": "Toaster, Repair, Electric, Kettle",
//       "Short Description":
//           "Professional electric kettle or toaster repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Induction/Electric Cooktop Repair",
//       "Suggested Tags": "Electric, Repair, Induction, Cooktop",
//       "Short Description":
//           "Professional induction/electric cooktop repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Mixer/Grinder Repair",
//       "Suggested Tags": "Repair, Grinder, Mixer",
//       "Short Description":
//           "Professional mixer/grinder repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Water Dispenser Repair",
//       "Suggested Tags": "Dispenser, Repair, Water",
//       "Short Description":
//           "Professional water dispenser repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Appliance Repair",
//       "Subcategory": "General",
//       "Service Name": "Room Heater Repair",
//       "Suggested Tags": "Room, Repair, Heater",
//       "Short Description": "Professional room heater repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per visit",
//     },
//     {
//       "Category": "Childcare & Tutoring",
//       "Subcategory": "General",
//       "Service Name": "Home Tutor",
//       "Suggested Tags": "Tutor, Study, Education",
//       "Short Description":
//           "Qualified tutors providing home-based academic support for students.",
//       "Estimated Price Range": "NPR 500 - 2,500",
//       "Service Duration": "Per session",
//     },
//     {
//       "Category": "Childcare & Tutoring",
//       "Subcategory": "General",
//       "Service Name": "Babysitting Service",
//       "Suggested Tags": "Child, Babysitter, Care",
//       "Short Description":
//           "Reliable babysitting and child supervision services.",
//       "Estimated Price Range": "NPR 500 - 2,500",
//       "Service Duration": "Per hour",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Kitchen Chimney Installation",
//       "Suggested Tags": "Chimney, Kitchen, Installation",
//       "Short Description":
//           "Professional kitchen chimney installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Kitchen Chimney Repair",
//       "Suggested Tags": "Chimney, Repair, Kitchen",
//       "Short Description":
//           "Professional kitchen chimney repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Kitchen Chimney Deep Cleaning",
//       "Suggested Tags": "Deep, Chimney, Kitchen, Cleaning",
//       "Short Description":
//           "Professional kitchen chimney deep cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Basic Room Cleaning",
//       "Suggested Tags": "Room, Basic, Cleaning",
//       "Short Description":
//           "Professional basic room cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Living Room Cleaning",
//       "Suggested Tags": "Room, Living, Cleaning",
//       "Short Description":
//           "Professional living room cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Bedroom Cleaning",
//       "Suggested Tags": "Bedroom, Cleaning",
//       "Short Description": "Professional bedroom cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Balcony Cleaning",
//       "Suggested Tags": "Cleaning, Balcony",
//       "Short Description": "Professional balcony cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Window & Glass Cleaning",
//       "Suggested Tags": "Glass, Window, Cleaning",
//       "Short Description":
//           "Professional window & glass cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Full House Deep Cleaning",
//       "Suggested Tags": "Full, Deep, House, Cleaning",
//       "Short Description":
//           "Professional full house deep cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Move-In/Move-Out Deep Cleaning",
//       "Suggested Tags": "Move-Out, Deep, Move-In, Cleaning",
//       "Short Description":
//           "Professional move-in/move-out deep cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Post-Construction Cleaning",
//       "Suggested Tags": "Post-Construction, Cleaning",
//       "Short Description":
//           "Professional post-construction cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Wall & Ceiling Cleaning",
//       "Suggested Tags": "Wall, Ceiling, Cleaning",
//       "Short Description":
//           "Professional wall & ceiling cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Door & Grille Cleaning",
//       "Suggested Tags": "Door, Grille, Cleaning",
//       "Short Description":
//           "Professional door & grille cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Modular Kitchen Deep Cleaning",
//       "Suggested Tags": "Deep, Kitchen, Modular, Cleaning",
//       "Short Description":
//           "Professional modular kitchen deep cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Kitchen Chimney Cleaning",
//       "Suggested Tags": "Chimney, Kitchen, Cleaning",
//       "Short Description":
//           "Professional kitchen chimney cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Shower Area Deep Cleaning",
//       "Suggested Tags": "Cleaning, Deep, Area, Shower",
//       "Short Description":
//           "Professional shower area deep cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Bathroom Tile & Grout Cleaning",
//       "Suggested Tags": "Cleaning, Bathroom, Tile, Grout",
//       "Short Description":
//           "Professional bathroom tile & grout cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Carpet Deep Cleaning",
//       "Suggested Tags": "Deep, Carpet, Cleaning",
//       "Short Description":
//           "Professional carpet deep cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Mattress Cleaning & Sanitization",
//       "Suggested Tags": "Sanitization, Mattress, Cleaning",
//       "Short Description":
//           "Professional mattress cleaning & sanitization service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Curtain Dry Cleaning",
//       "Suggested Tags": "Dry, Curtain, Cleaning",
//       "Short Description":
//           "Professional curtain dry cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Office Room Cleaning",
//       "Suggested Tags": "Room, Office, Cleaning",
//       "Short Description":
//           "Professional office room cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Pantry & Restroom Cleaning",
//       "Suggested Tags": "Restroom, Pantry, Cleaning",
//       "Short Description":
//           "Professional pantry & restroom cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Dashain-Tihar Festival Cleaning",
//       "Suggested Tags": "Festival, Dashain-Tihar, Cleaning",
//       "Short Description":
//           "Professional dashain-tihar festival cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Pre-Winter House Cleaning",
//       "Suggested Tags": "Pre-Winter, House, Cleaning",
//       "Short Description":
//           "Professional pre-winter house cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Monsoon Mold Prevention Cleaning",
//       "Suggested Tags": "Prevention, Monsoon, Mold, Cleaning",
//       "Short Description":
//           "Professional monsoon mold prevention cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Custom Cleaning Request",
//       "Suggested Tags": "Cleaning, Request, Custom",
//       "Short Description":
//           "Professional custom cleaning request service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Chimney/Exhaust Duct Cleaning",
//       "Suggested Tags": "Chimney, Duct, Exhaust, Cleaning",
//       "Short Description":
//           "Professional chimney/exhaust duct cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Cleaning & Housekeeping",
//       "Subcategory": "General",
//       "Service Name": "Laundry & Dry Cleaning Pickup/Delivery",
//       "Suggested Tags": "Pickup, Cleaning, Dry, Delivery, Laundry",
//       "Short Description":
//           "Professional laundry & dry cleaning pickup/delivery service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Digital & IT",
//       "Subcategory": "Web Development",
//       "Service Name": "Website Development",
//       "Suggested Tags": "Website, IT, Digital",
//       "Short Description":
//           "Custom website development and maintenance services.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per project",
//     },
//     {
//       "Category": "Digital & IT",
//       "Subcategory": "Mobile Apps",
//       "Service Name": "Mobile App Troubleshooting",
//       "Suggested Tags": "App, Mobile, Tech",
//       "Short Description":
//           "Support and troubleshooting for mobile applications.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per hour",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Ceiling Fan Installation",
//       "Suggested Tags": "Fan, Ceiling, Installation",
//       "Short Description":
//           "Professional ceiling fan installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Wall Fan Installation",
//       "Suggested Tags": "Wall, Fan, Installation",
//       "Short Description":
//           "Professional wall fan installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "LED Light Installation",
//       "Suggested Tags": "Light, LED, Installation",
//       "Short Description":
//           "Professional led light installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Tube Light Installation",
//       "Suggested Tags": "Tube, Light, Installation",
//       "Short Description":
//           "Professional tube light installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Power Socket Installation",
//       "Suggested Tags": "Socket, Power, Installation",
//       "Short Description":
//           "Professional power socket installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Switchboard Installation",
//       "Suggested Tags": "Switchboard, Installation",
//       "Short Description":
//           "Professional switchboard installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Chandelier or Fancy Light Setup",
//       "Suggested Tags": "Setup, Fancy, Light, Chandelier",
//       "Short Description":
//           "Professional chandelier or fancy light setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Exhaust Fan Installation",
//       "Suggested Tags": "Fan, Exhaust, Installation",
//       "Short Description":
//           "Professional exhaust fan installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Ceiling Fan Repair",
//       "Suggested Tags": "Fan, Repair, Ceiling",
//       "Short Description": "Professional ceiling fan repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Switch or Socket Repair",
//       "Suggested Tags": "Repair, Socket, Switch",
//       "Short Description":
//           "Professional switch or socket repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Light Flickering Issue Repair",
//       "Suggested Tags": "Issue, Repair, Light, Flickering",
//       "Short Description":
//           "Professional light flickering issue repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Wiring Fault Fix",
//       "Suggested Tags": "Wiring, Fault, Fix",
//       "Short Description": "Professional wiring fault fix service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "MCB or DB Board Repair",
//       "Suggested Tags": "Repair, Board, MCB",
//       "Short Description":
//           "Professional mcb or db board repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Inverter Troubleshooting",
//       "Suggested Tags": "Inverter, Troubleshooting",
//       "Short Description":
//           "Professional inverter troubleshooting service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Appliance Earthing Issue Fix",
//       "Suggested Tags": "Issue, Appliance, Earthing, Fix",
//       "Short Description":
//           "Professional appliance earthing issue fix service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Extension Socket Repair",
//       "Suggested Tags": "Repair, Socket, Extension",
//       "Short Description":
//           "Professional extension socket repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Electrical Safety Inspection",
//       "Suggested Tags": "Inspection, Electrical, Safety",
//       "Short Description":
//           "Professional electrical safety inspection service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Earthing Check & Repair",
//       "Suggested Tags": "Repair, Check, Earthing",
//       "Short Description":
//           "Professional earthing check & repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Wiring Audit",
//       "Suggested Tags": "Wiring, Audit",
//       "Short Description": "Professional wiring audit service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Full House Wiring (New Construction)",
//       "Suggested Tags": "Construction), (New, Wiring, House, Full",
//       "Short Description":
//           "Professional full house wiring (new construction) service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Rewiring (Old House)",
//       "Suggested Tags": "House), Rewiring, (Old",
//       "Short Description":
//           "Professional rewiring (old house) service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Energy Efficient Lighting Upgrade",
//       "Suggested Tags": "Upgrade, Lighting, Energy, Efficient",
//       "Short Description":
//           "Professional energy efficient lighting upgrade service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Smart Switch Setup",
//       "Suggested Tags": "Switch, Setup, Smart",
//       "Short Description": "Professional smart switch setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Custom Electrical Request",
//       "Suggested Tags": "Electrical, Request, Custom",
//       "Short Description":
//           "Professional custom electrical request service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Solar Panel System Wiring Support",
//       "Suggested Tags": "Panel, System, Wiring, Solar, Support",
//       "Short Description":
//           "Professional solar panel system wiring support service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Battery Bank/Inverter Battery Replacement",
//       "Suggested Tags": "Replacement, Inverter, Bank, Battery",
//       "Short Description":
//           "Professional battery bank/inverter battery replacement service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Generator to Home Power Setup",
//       "Suggested Tags": "Home, Generator, Power, Setup",
//       "Short Description":
//           "Professional generator to home power setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Office Lighting Setup",
//       "Suggested Tags": "Office, Setup, Lighting",
//       "Short Description":
//           "Professional office lighting setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "LAN Cable Wiring",
//       "Suggested Tags": "Wiring, Cable, LAN",
//       "Short Description": "Professional lan cable wiring service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "UPS System Wiring",
//       "Suggested Tags": "UPS, Wiring, System",
//       "Short Description": "Professional ups system wiring service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Annual Electrical Maintenance Package",
//       "Suggested Tags": "Electrical, Annual, Maintenance, Package",
//       "Short Description":
//           "Professional annual electrical maintenance package service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Appliance Electrical Fault Inspection",
//       "Suggested Tags": "Inspection, Electrical, Appliance, Fault",
//       "Short Description":
//           "Professional appliance electrical fault inspection service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Ceiling Fan & Cobweb Cleaning",
//       "Suggested Tags": "Fan, Cobweb, Ceiling, Cleaning",
//       "Short Description":
//           "Professional ceiling fan & cobweb cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Generator Installation & Service",
//       "Suggested Tags": "Generator, Service, Installation",
//       "Short Description":
//           "Professional generator installation & service service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "General",
//       "Service Name": "Short Circuit Repair",
//       "Suggested Tags": "Short, Circuit, Repair",
//       "Short Description":
//           "Professional short circuit repair service available.",
//       "Estimated Price Range": "NPR 1,000 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical",
//       "Subcategory": "Fuse & Circuit",
//       "Service Name": "Emergency Fuse Burnout",
//       "Suggested Tags": "Burnout, Emergency, Fuse",
//       "Short Description":
//           "Professional emergency fuse burnout service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Geyser Installation",
//       "Suggested Tags": "Geyser, Installation",
//       "Short Description":
//           "Professional geyser installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Bidet Spray Installation",
//       "Suggested Tags": "Spray, Bidet, Installation",
//       "Short Description":
//           "Professional bidet spray installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Inverter Installation & Setup",
//       "Suggested Tags": "Inverter, Setup, Installation",
//       "Short Description":
//           "Professional inverter installation & setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Electric Water Heater (Geyser) Installation",
//       "Suggested Tags": "Installation, Heater, Electric, Water, (Geyser)",
//       "Short Description":
//           "Professional electric water heater (geyser) installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Smart Home Device Setup",
//       "Suggested Tags": "Home, Setup, Device, Smart",
//       "Short Description":
//           "Professional smart home device setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "CCTV Wiring and Setup Support",
//       "Suggested Tags": "Wiring, and, Support, CCTV, Setup",
//       "Short Description":
//           "Professional cctv wiring and setup support service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Washing Machine Installation",
//       "Suggested Tags": "Washing, Machine, Installation",
//       "Short Description":
//           "Professional washing machine installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Air Conditioner (AC) Installation",
//       "Suggested Tags": "Conditioner, Air, (AC), Installation",
//       "Short Description":
//           "Professional air conditioner (ac) installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Water Purifier Installation",
//       "Suggested Tags": "Purifier, Water, Installation",
//       "Short Description":
//           "Professional water purifier installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Dishwasher Installation",
//       "Suggested Tags": "Dishwasher, Installation",
//       "Short Description":
//           "Professional dishwasher installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Induction or Electric Cooktop Setup",
//       "Suggested Tags": "Electric, Setup, Induction, Cooktop",
//       "Short Description":
//           "Professional induction or electric cooktop setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Smart TV Setup (with WiFi/OTT configuration)",
//       "Suggested Tags": "(with, OTT, Smart, Setup, configuration), WiFi",
//       "Short Description":
//           "Professional smart tv setup (with wifi/ott configuration) service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Air Purifier Installation & Repair",
//       "Suggested Tags": "Air, Purifier, Repair, Installation",
//       "Short Description":
//           "Professional air purifier installation & repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Room Heater Installation",
//       "Suggested Tags": "Room, Heater, Installation",
//       "Short Description":
//           "Professional room heater installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Rooftop Solar Panel Installation",
//       "Suggested Tags": "Installation, Solar, Panel, Rooftop",
//       "Short Description":
//           "Professional rooftop solar panel installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Inverter/UPS Installation & Service",
//       "Suggested Tags": "UPS, Inverter, Service, Installation",
//       "Short Description":
//           "Professional inverter/ups installation & service service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Water Purifier (RO/UF) Installation & Service",
//       "Suggested Tags": "Installation, UF), Purifier, Water, (RO, Service",
//       "Short Description":
//           "Professional water purifier (ro/uf) installation & service service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Mosquito Net Installation/Repair",
//       "Suggested Tags": "Installation, Repair, Net, Mosquito",
//       "Short Description":
//           "Professional mosquito net installation/repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Electrical Appliances",
//       "Subcategory": "General",
//       "Service Name": "Solar Water Heater Installation & Service",
//       "Suggested Tags": "Installation, Solar, Heater, Water, Service",
//       "Short Description":
//           "Professional solar water heater installation & service service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Event Support",
//       "Subcategory": "Wedding Services",
//       "Service Name": "Wedding Organizer",
//       "Suggested Tags": "Wedding, Event, Organizer",
//       "Short Description": "Complete wedding planning and organizing services.",
//       "Estimated Price Range": "NPR 1,000 - 8,000",
//       "Service Duration": "Per event",
//     },
//     {
//       "Category": "Event Support",
//       "Subcategory": "Catering",
//       "Service Name": "Catering Service",
//       "Suggested Tags": "Food, Catering, Event",
//       "Short Description":
//           "Professional catering for events, rituals, and celebrations.",
//       "Estimated Price Range": "NPR 1,000 - 8,000",
//       "Service Duration": "Per event",
//     },
//     {
//       "Category": "Garden & Lawn Care",
//       "Subcategory": "General",
//       "Service Name": "Garden Tap System Installation",
//       "Suggested Tags": "Installation, Tap, System, Garden",
//       "Short Description":
//           "Professional garden tap system installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Plumbing Health Checkup (Inspection)",
//       "Suggested Tags": "Health, Plumbing, (Inspection), Checkup",
//       "Short Description":
//           "Professional plumbing health checkup (inspection) service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "New House Plumbing",
//       "Suggested Tags": "Plumbing, New, House",
//       "Short Description": "Professional new house plumbing service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Pressure Pump Maintenance",
//       "Suggested Tags": "Pressure, Maintenance, Pump",
//       "Short Description":
//           "Professional pressure pump maintenance service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Custom Plumbing Request",
//       "Suggested Tags": "Request, Plumbing, Custom",
//       "Short Description":
//           "Professional custom plumbing request service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Load Balancing Assessment",
//       "Suggested Tags": "Assessment, Balancing, Load",
//       "Short Description":
//           "Professional load balancing assessment service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Voltage Fluctuation Diagnosis",
//       "Suggested Tags": "Fluctuation, Voltage, Diagnosis",
//       "Short Description":
//           "Professional voltage fluctuation diagnosis service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "3-Phase to Single Phase Conversion",
//       "Suggested Tags": "Single, Conversion, Phase, 3-Phase",
//       "Short Description":
//           "Professional 3-phase to single phase conversion service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "24/7 Emergency Power Outage",
//       "Suggested Tags": "Emergency, Power, Outage",
//       "Short Description":
//           "Professional 24/7 emergency power outage service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Emergency Short Circuit",
//       "Suggested Tags": "Short, Emergency, Circuit",
//       "Short Description":
//           "Professional emergency short circuit service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Preventive Load Testing",
//       "Suggested Tags": "Preventive, Testing, Load",
//       "Short Description":
//           "Professional preventive load testing service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "General Appliance Health Check",
//       "Suggested Tags": "Check, Health, General, Appliance",
//       "Short Description":
//           "Professional general appliance health check service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Emergency Appliance Breakdown Support",
//       "Suggested Tags": "Emergency, Support, Appliance, Breakdown",
//       "Short Description":
//           "Professional emergency appliance breakdown support service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Custom Appliance Request",
//       "Suggested Tags": "Request, Appliance, Custom",
//       "Short Description":
//           "Professional custom appliance request service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Winter Appliance Health Check",
//       "Suggested Tags": "Check, Health, Winter, Appliance",
//       "Short Description":
//           "Professional winter appliance health check service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Quarterly Appliance Servicing Plan",
//       "Suggested Tags": "Servicing, Appliance, Quarterly, Plan",
//       "Short Description":
//           "Professional quarterly appliance servicing plan service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "General Services",
//       "Subcategory": "General",
//       "Service Name": "Workstation & Electronics Dusting",
//       "Suggested Tags": "Electronics, Dusting, Workstation",
//       "Short Description":
//           "Professional workstation & electronics dusting service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Health & Personal Care",
//       "Subcategory": "General",
//       "Service Name": "Home Nursing Care",
//       "Suggested Tags": "Nursing, Health, Home Care",
//       "Short Description":
//           "Professional nursing support provided at home for recovery and elderly care.",
//       "Estimated Price Range": "NPR 1,500 - 7,000",
//       "Service Duration": "Per shift",
//     },
//     {
//       "Category": "Health & Personal Care",
//       "Subcategory": "General",
//       "Service Name": "Physiotherapy at Home",
//       "Suggested Tags": "Physio, Exercise, Health",
//       "Short Description":
//           "Certified physiotherapists providing rehabilitation and therapy services at home.",
//       "Estimated Price Range": "NPR 1,500 - 7,000",
//       "Service Duration": "Per session",
//     },
//     {
//       "Category": "Home Repair & Renovation",
//       "Subcategory": "General",
//       "Service Name": "Doorbell Camera Installation",
//       "Suggested Tags": "Camera, Installation, Doorbell",
//       "Short Description":
//           "Professional doorbell camera installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Home Repair & Renovation",
//       "Subcategory": "General",
//       "Service Name": "Smart Door Lock Installation",
//       "Suggested Tags": "Lock, Door, Smart, Installation",
//       "Short Description":
//           "Professional smart door lock installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Home Repair & Renovation",
//       "Subcategory": "General",
//       "Service Name": "Marble/Tile Polishing",
//       "Suggested Tags": "Tile, Marble, Polishing",
//       "Short Description":
//           "Professional marble/tile polishing service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Local Tourism & Trekking",
//       "Subcategory": "General",
//       "Service Name": "Local Trekking Guide",
//       "Suggested Tags": "Trekking, Guide, Tourism",
//       "Short Description":
//           "Experienced trekking guides for local and international tourists.",
//       "Estimated Price Range": "NPR 1,000 - 4,000",
//       "Service Duration": "Per day",
//     },
//     {
//       "Category": "Local Tourism & Trekking",
//       "Subcategory": "General",
//       "Service Name": "Porter Service",
//       "Suggested Tags": "Porter, Tourism, Trekking",
//       "Short Description":
//           "Reliable porter services for treks and expeditions.",
//       "Estimated Price Range": "NPR 1,000 - 4,000",
//       "Service Duration": "Per day",
//     },
//     {
//       "Category": "Pest Control",
//       "Subcategory": "General",
//       "Service Name": "Termite Inspection & Treatment",
//       "Suggested Tags": "Inspection, Treatment, Termite",
//       "Short Description":
//           "Professional termite inspection & treatment service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Pest Control",
//       "Subcategory": "General",
//       "Service Name": "Rodent Control Service",
//       "Suggested Tags": "Rodent, Control, Service",
//       "Short Description":
//           "Professional rodent control service service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Pest Control",
//       "Subcategory": "General",
//       "Service Name": "Pest Control (Termites/Rodents/Mosquito)",
//       "Suggested Tags": "Mosquito), Control, Pest, Rodents, (Termites",
//       "Short Description":
//           "Professional pest control (termites/rodents/mosquito) service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Tap/Faucet Installation",
//       "Suggested Tags": "Faucet, Tap, Installation",
//       "Short Description":
//           "Professional tap/faucet installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Water Tank Installation",
//       "Suggested Tags": "Tank, Water, Installation",
//       "Short Description":
//           "Professional water tank installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Western/Indian Toilet Installation",
//       "Suggested Tags": "Installation, Indian, Western, Toilet",
//       "Short Description":
//           "Professional western/indian toilet installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Bathtub Installation",
//       "Suggested Tags": "Bathtub, Installation",
//       "Short Description":
//           "Professional bathtub installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Drainage Pipe Installation",
//       "Suggested Tags": "Pipe, Drainage, Installation",
//       "Short Description":
//           "Professional drainage pipe installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Water Supply Pipeline Setup",
//       "Suggested Tags": "Supply, Pipeline, Setup, Water",
//       "Short Description":
//           "Professional water supply pipeline setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Overhead Tank Connection Setup",
//       "Suggested Tags": "Tank, Setup, Connection, Overhead",
//       "Short Description":
//           "Professional overhead tank connection setup service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Leaking Tap Repair",
//       "Suggested Tags": "Repair, Tap, Leaking",
//       "Short Description": "Professional leaking tap repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Toilet Flush Repair",
//       "Suggested Tags": "Repair, Flush, Toilet",
//       "Short Description":
//           "Professional toilet flush repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Basin Repair",
//       "Suggested Tags": "Repair, Basin",
//       "Short Description": "Professional basin repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Clogged Drain Cleaning",
//       "Suggested Tags": "Cleaning, Clogged, Drain",
//       "Short Description":
//           "Professional clogged drain cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Water Pipe Leakage",
//       "Suggested Tags": "Pipe, Leakage, Water",
//       "Short Description": "Professional water pipe leakage service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Geyser Repair",
//       "Suggested Tags": "Geyser, Repair",
//       "Short Description": "Professional geyser repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Underground Pipe Leak",
//       "Suggested Tags": "Pipe, Underground, Leak",
//       "Short Description":
//           "Professional underground pipe leak service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Overhead Tank Cleaning",
//       "Suggested Tags": "Cleaning, Tank, Overhead",
//       "Short Description":
//           "Professional overhead tank cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Underground Water Tank Cleaning",
//       "Suggested Tags": "Tank, Underground, Water, Cleaning",
//       "Short Description":
//           "Professional underground water tank cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Septic Tank Cleaning",
//       "Suggested Tags": "Septic, Tank, Cleaning",
//       "Short Description":
//           "Professional septic tank cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Pipeline Flushing and Cleaning",
//       "Suggested Tags": "Flushing, Pipeline, and, Cleaning",
//       "Short Description":
//           "Professional pipeline flushing and cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Bore Water Pipeline Connection",
//       "Suggested Tags": "Bore, Pipeline, Connection, Water",
//       "Short Description":
//           "Professional bore water pipeline connection service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Sensor Tap Installation",
//       "Suggested Tags": "Tap, Sensor, Installation",
//       "Short Description":
//           "Professional sensor tap installation service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "24/7 Emergency Pipe Burst",
//       "Suggested Tags": "Pipe, Emergency, Burst",
//       "Short Description":
//           "Professional 24/7 emergency pipe burst service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Emergency Drain Unclogging",
//       "Suggested Tags": "Emergency, Unclogging, Drain",
//       "Short Description":
//           "Professional emergency drain unclogging service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Emergency Geyser Leak Management",
//       "Suggested Tags": "Geyser, Emergency, Management, Leak",
//       "Short Description":
//           "Professional emergency geyser leak management service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Toilet & Sink Descaling",
//       "Suggested Tags": "Descaling, Sink, Toilet",
//       "Short Description":
//           "Professional toilet & sink descaling service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Overhead Water Tank Cleaning",
//       "Suggested Tags": "Cleaning, Tank, Water, Overhead",
//       "Short Description":
//           "Professional overhead water tank cleaning service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Septic Tank Cleaning/Emptying",
//       "Suggested Tags": "Emptying, Septic, Tank, Cleaning",
//       "Short Description":
//           "Professional septic tank cleaning/emptying service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Sewage Treatment Plant Maintenance",
//       "Suggested Tags": "Plant, Sewage, Treatment, Maintenance",
//       "Short Description":
//           "Professional sewage treatment plant maintenance service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Roof Leak Repair",
//       "Suggested Tags": "Roof, Repair, Leak",
//       "Short Description": "Professional roof leak repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Sump Pump Installation & Repair",
//       "Suggested Tags": "Pump, Sump, Repair, Installation",
//       "Short Description":
//           "Professional sump pump installation & repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General",
//       "Service Name": "Gutter Cleaning & Repair",
//       "Suggested Tags": "Gutter, Repair, Cleaning",
//       "Short Description":
//           "Professional gutter cleaning & repair service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General Plumbing",
//       "Service Name": "Low Water Pressure",
//       "Suggested Tags": "Pressure, Low, Water",
//       "Short Description": "Professional low water pressure service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "Bathroom Fixtures",
//       "Service Name": "Bathroom Plumbing Remodeling",
//       "Suggested Tags": "Bathroom, Plumbing, Remodeling",
//       "Short Description":
//           "Professional bathroom plumbing remodeling service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General Plumbing",
//       "Service Name": "Borewell Water Line Integration",
//       "Suggested Tags": "Borewell, Line, Integration, Water",
//       "Short Description":
//           "Professional borewell water line integration service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Plumbing",
//       "Subcategory": "General Plumbing",
//       "Service Name": "Rainwater Harvesting System Plumbing",
//       "Suggested Tags": "Harvesting, Rainwater, Plumbing, System",
//       "Short Description":
//           "Professional rainwater harvesting system plumbing service available.",
//       "Estimated Price Range": "NPR 500 - 5,000",
//       "Service Duration": "Per job",
//     },
//     {
//       "Category": "Traditional & Cultural",
//       "Subcategory": "General",
//       "Service Name": "Priest/Pandit Booking",
//       "Suggested Tags": "Priest, Ritual, Ceremony",
//       "Short Description":
//           "Pandit services for Hindu rituals, pujas, and ceremonies.",
//       "Estimated Price Range": "NPR 1,000 - 8,000",
//       "Service Duration": "Per event",
//     },
//     {
//       "Category": "Traditional & Cultural",
//       "Subcategory": "General",
//       "Service Name": "Astrology Consultation",
//       "Suggested Tags": "Astrology, Horoscope, Ritual",
//       "Short Description":
//           "Professional astrology and horoscope consultation services.",
//       "Estimated Price Range": "NPR 1,000 - 8,000",
//       "Service Duration": "Per session",
//     },
//     {
//       "Category": "Transportation & Delivery",
//       "Subcategory": "General",
//       "Service Name": "Motorbike Courier Service",
//       "Suggested Tags": "Courier, Bike, Delivery",
//       "Short Description":
//           "Fast and reliable bike delivery services for small packages.",
//       "Estimated Price Range": "NPR 300 - 2,000",
//       "Service Duration": "Per delivery",
//     },
//     {
//       "Category": "Transportation & Delivery",
//       "Subcategory": "General",
//       "Service Name": "Pickup & Drop Service",
//       "Suggested Tags": "Transport, Pickup, Drop",
//       "Short Description":
//           "Affordable pickup and drop services for local travel.",
//       "Estimated Price Range": "NPR 300 - 2,000",
//       "Service Duration": "Per trip",
//     },
//   ];

//   Future<void> seed() async {
//     const uuid = Uuid();

//     try {
//       final existingDocs = await _firestore
//           .collection('hardcoded_services_info')
//           .get();
//       for (final doc in existingDocs.docs) {
//         await doc.reference.delete();
//       }
//       print("Cleared existing service data.");

//       Map<String, List<Map<String, dynamic>>> groupedServices = {};
//       for (final service in allServices) {
//         final category = service['Category'] as String;
//         if (!groupedServices.containsKey(category)) {
//           groupedServices[category] = [];
//         }
//         groupedServices[category]!.add(service);
//       }

//       for (final categoryEntry in groupedServices.entries) {
//         final categoryName = categoryEntry.key;
//         final services = categoryEntry.value;

//         final List<Map<String, dynamic>> subcats = services.map((service) {
//           final priceInfo = parsePriceRange(service['Estimated Price Range']);

//           return {
//             "id": uuid.v4(),
//             "name": service['Service Name'],
//             "description": service['Short Description'],
//             "keywords": parseKeywords(service['Suggested Tags']),
//             "subcategory": service['Subcategory'],
//             "imageUrl": generateImageUrl(service['Service Name'], categoryName),
//             "pricing": {
//               "minPrice": priceInfo['minPrice'],
//               "maxPrice": priceInfo['maxPrice'],
//               "basePrice": priceInfo['basePrice'],
//               "currency": priceInfo['currency'],
//               "unit": service['Service Duration'],
//             },
//             "isActive": true,
//           };
//         }).toList();

//         final List<String> categoryImages = generateCategoryImages(
//           categoryName,
//         );

//         final Map<String, dynamic> docData = {
//           "category": categoryName,
//           "categoryId": uuid.v4(),
//           "imageUrls": categoryImages,
//           "heroImageUrl": categoryImages[0],
//           "subcategories": subcats,
//           "totalServices": subcats.length,
//           "isActive": true,
//           "createdAt": FieldValue.serverTimestamp(),
//           "updatedAt": FieldValue.serverTimestamp(),
//           "metadata": {
//             "averagePrice": subcats.isNotEmpty
//                 ? subcats
//                           .map((s) => s['pricing']['basePrice'])
//                           .reduce((a, b) => a + b) /
//                       subcats.length
//                 : 0,
//             "priceRange": {
//               "min": subcats.isNotEmpty
//                   ? subcats
//                         .map((s) => s['pricing']['minPrice'])
//                         .reduce((a, b) => a < b ? a : b)
//                   : 0,
//               "max": subcats.isNotEmpty
//                   ? subcats
//                         .map((s) => s['pricing']['maxPrice'])
//                         .reduce((a, b) => a > b ? a : b)
//                   : 0,
//             },
//           },
//         };

//         await _firestore.collection('hardcoded_services_info').add(docData);
//         print("Added category: $categoryName with ${subcats.length} services");
//       }

//       print(" Service seeding completed successfully!");
//       print(" Total categories: ${groupedServices.length}");
//       print(" Total services: ${allServices.length}");
//     } catch (e) {
//       print(" Error during seeding: $e");
//       rethrow;
//     }
//   }

//   Future<Map<String, dynamic>> getServiceStats() async {
//     final snapshot = await _firestore
//         .collection('hardcoded_services_info')
//         .get();

//     int totalCategories = snapshot.docs.length;
//     int totalServices = 0;
//     List<double> allPrices = [];

//     for (final doc in snapshot.docs) {
//       final data = doc.data();
//       final subcategories = data['subcategories'] as List<dynamic>? ?? [];
//       totalServices += subcategories.length;

//       for (final service in subcategories) {
//         final pricing = service['pricing'] as Map<String, dynamic>? ?? {};
//         final basePrice = pricing['basePrice'] as num? ?? 0;
//         if (basePrice > 0) {
//           allPrices.add(basePrice.toDouble());
//         }
//       }
//     }

//     double averagePrice = allPrices.isNotEmpty
//         ? allPrices.reduce((a, b) => a + b) / allPrices.length
//         : 0;

//     double minPrice = allPrices.isNotEmpty
//         ? allPrices.reduce((a, b) => a < b ? a : b)
//         : 0;

//     double maxPrice = allPrices.isNotEmpty
//         ? allPrices.reduce((a, b) => a > b ? a : b)
//         : 0;

//     return {
//       'totalCategories': totalCategories,
//       'totalServices': totalServices,
//       'averagePrice': averagePrice.round(),
//       'priceRange': {'min': minPrice.round(), 'max': maxPrice.round()},
//       'currency': 'NPR',
//     };
//   }

//   Future<void> seedAndShowStats() async {
//     await seed();
//     final stats = await getServiceStats();
//     print("\n SEEDING STATISTICS:");
//     print("Categories: ${stats['totalCategories']}");
//     print("Total Services: ${stats['totalServices']}");
//     print("Average Price: ${stats['currency']} ${stats['averagePrice']}");
//     print(
//       "Price Range: ${stats['currency']} ${stats['priceRange']['min']} - ${stats['priceRange']['max']}",
//     );
//   }

//   Future<void> seedCategory(String categoryName) async {
//     const uuid = Uuid();

//     final categoryServices = allServices
//         .where((service) => service['Category'] == categoryName)
//         .toList();

//     if (categoryServices.isEmpty) {
//       print("No services found for category: $categoryName");
//       return;
//     }

//     final List<Map<String, dynamic>> subcats = categoryServices.map((service) {
//       final priceInfo = parsePriceRange(service['Estimated Price Range']);

//       return {
//         "id": uuid.v4(),
//         "name": service['Service Name'],
//         "description": service['Short Description'],
//         "keywords": parseKeywords(service['Suggested Tags']),
//         "subcategory": service['Subcategory'],
//         "imageUrl": generateImageUrl(service['Service Name'], categoryName),
//         "pricing": {
//           "minPrice": priceInfo['minPrice'],
//           "maxPrice": priceInfo['maxPrice'],
//           "basePrice": priceInfo['basePrice'],
//           "currency": priceInfo['currency'],
//           "unit": service['Service Duration'],
//         },
//         "isActive": true,
//       };
//     }).toList();

//     final List<String> categoryImages = generateCategoryImages(categoryName);

//     final Map<String, dynamic> docData = {
//       "category": categoryName,
//       "categoryId": uuid.v4(),
//       "imageUrls": categoryImages,
//       "heroImageUrl": categoryImages[0],
//       "subcategories": subcats,
//       "totalServices": subcats.length,
//       "isActive": true,
//       "createdAt": FieldValue.serverTimestamp(),
//       "updatedAt": FieldValue.serverTimestamp(),
//       "metadata": {
//         "averagePrice": subcats.isNotEmpty
//             ? subcats
//                       .map((s) => s['pricing']['basePrice'])
//                       .reduce((a, b) => a + b) /
//                   subcats.length
//             : 0,
//         "priceRange": {
//           "min": subcats.isNotEmpty
//               ? subcats
//                     .map((s) => s['pricing']['minPrice'])
//                     .reduce((a, b) => a < b ? a : b)
//               : 0,
//           "max": subcats.isNotEmpty
//               ? subcats
//                     .map((s) => s['pricing']['maxPrice'])
//                     .reduce((a, b) => a > b ? a : b)
//               : 0,
//         },
//       },
//     };

//     final existingQuery = await _firestore
//         .collection('hardcoded_services_info')
//         .where('category', isEqualTo: categoryName)
//         .get();

//     for (final doc in existingQuery.docs) {
//       await doc.reference.delete();
//     }

//     await _firestore.collection('hardcoded_services_info').add(docData);
//     print("Updated category: $categoryName with ${subcats.length} services");
//   }
// }
