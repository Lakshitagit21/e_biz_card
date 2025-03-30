import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/contact_model.dart';
import '../providers/contact_provider.dart';
import '../utils/helper_functions.dart';

class ContactDetailsPage extends StatefulWidget {
  static const String routeName = 'details';
  final int id;

  const ContactDetailsPage({super.key, required this.id});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late int id;

  @override
  void initState() {
    id = widget.id;
    print(id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, child) =>
            FutureBuilder<ContactModel>(
              future: provider.getContactById(id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final contact = snapshot.data!;
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: [
                      Image.file(File(contact.image), width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,),
                      ListTile(
                        title: Text(contact.mobile),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                callContact(contact.mobile);
                              },
                              icon: const Icon(Icons.call),
                            ),
                            IconButton(
                              onPressed: () {
                                smsContact(contact.mobile);
                              },
                              icon: const Icon(Icons.sms),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text(contact.email.isEmpty ? 'Not found' : contact.email),
                        trailing: IconButton(
                          onPressed: () {
                            _sendEmail(contact.email);
                          },
                          icon: const Icon(Icons.email),
                        ),
                      ),
                      ListTile(
                        title: Text(contact.address.isEmpty ? 'Not found' : contact.address),
                        trailing: IconButton(
                          onPressed: () {
                            _openMap(contact.address);
                          },
                          icon: const Icon(Icons.map),
                        ),
                      ),
                      ListTile(
                        title: Text(contact.website.isEmpty ? 'Not found' : contact.website),
                        trailing: IconButton(
                          onPressed: () {
                            _openBrowser(contact.website);
                          },
                          icon: const Icon(Icons.web),
                        ),
                      ),
                    ],
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Failed to load data'),);
                }
                return const Center(child: Text('Please wait...'),);
              },
            ),
      ),
    );
  }
  void callContact(String mobile) async {
    final url = 'tel:$mobile';
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }

  void smsContact(String mobile) async {
    final url = 'sms:$mobile';
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Cannot perform this task');
    }
  }
  void _sendEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _openBrowser(String website) async {
    final url = 'https://$website';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }

  void _openMap(String address) async {
    String url = '';
    if (Platform.isAndroid) {
      url = 'geo:0,0?q=$address';
    } else {
      url = 'http://maps.apple.com/?q=$address';
    }
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      showMsg(context, 'Could not perform this operation');
    }
  }
}
