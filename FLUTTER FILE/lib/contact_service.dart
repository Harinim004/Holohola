import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

/// ✅ Fetch contacts and return a list
Future<List<Contact>> fetchContacts() async {
  List<Contact> contactList = [];

  // Request permission
  if (await Permission.contacts.request().isGranted) {
    contactList = await FlutterContacts.getContacts(
      withProperties: true,
      withPhoto: true,
    );
  } else {
    print("Contacts permission denied.");
  }

  return contactList;
}

/// ✅ Opens the phone dialer with the given number.
Future<void> openContactDetails(String phoneNumber) async {
  List<Contact> contacts = await fetchContacts();

  // Find the contact matching the phone number
  Contact selectedContact = contacts.firstWhere(
        (contact) => contact.phones.isNotEmpty &&
        contact.phones.any((phone) => phone.number.replaceAll(' ', '') == phoneNumber.replaceAll(' ', '')),
    orElse: () => Contact(name: Name(first: "Unknown")),
  );

  if (selectedContact.name.first != "Unknown") {
    // Open dialer with the contact's number
    final Uri callUri = Uri.parse("tel:${selectedContact.phones.first.number}");
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  } else {
    print("Contact not found.");
  }
}
