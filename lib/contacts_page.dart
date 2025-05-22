import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'contact_service.dart';


class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> filteredContacts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    List<Contact> fetchedContacts = await fetchContacts();
    setState(() {
      contacts = fetchedContacts;
      filteredContacts = fetchedContacts;
      isLoading = false;
    });
  }

  void _filterContacts(String query) {
    setState(() {
      filteredContacts = contacts
          .where((contact) => contact.displayName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.blueAccent,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search contacts...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
              ),
              onChanged: _filterContacts,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredContacts.isEmpty
          ? Center(child: Text("No contacts found"))
          : ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          Contact contact = filteredContacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(contact.displayName),
            subtitle: Text(contact.phones.isNotEmpty
                ? contact.phones.first.number
                : "No phone number"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: Colors.blueAccent),
                  onPressed: () {
                    if (contact.phones.isNotEmpty) {
                      openContactDetails(contact.phones.first.number);
                    } else {
                      print("No phone number available.");
                    }
                  },
                ),
               /* IconButton(
                  icon: Icon(Icons.person_outline, color: Colors.blueAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactProfilePage(contact: contact),
                      ),
                    );
                  },
                ),*/
              ],
            ),
           /* onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContactProfilePage(contact: contact),
                ),
              );
            },*/
          );
        },
      ),
    );
  }
}
