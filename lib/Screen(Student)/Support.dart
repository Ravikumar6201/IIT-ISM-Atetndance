import 'package:flutter/material.dart';
import 'package:ism/Class/Colorconstat.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Support",
          style: TextStyle(color: ColorConstant.whiteA700),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: ColorConstant.whiteA700,
          ),
        ),
        backgroundColor: ColorConstant.lightBlue701,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildHeader(context),
          const SizedBox(height: 20),
          _buildSupportOption(
            context,
            icon: Icons.help_outline,
            title: 'FAQ',
            subtitle: 'Frequently Asked Questions',
            onTap: () {
              // Navigate to FAQ page or show FAQ content
            },
          ),
          _buildSupportOption(
            context,
            icon: Icons.contact_mail,
            title: 'Contact Us',
            subtitle: 'Get in touch with our support team',
            onTap: () {
              // Navigate to Contact Us page or show contact form
            },
          ),
          _buildSupportOption(
            context,
            icon: Icons.feedback,
            title: 'Feedback',
            subtitle: 'Give us your feedback',
            onTap: () {
              // Navigate to Feedback page or show feedback form
            },
          ),
          _buildSupportOption(
            context,
            icon: Icons.info_outline,
            title: 'About Us',
            subtitle: 'Learn more about our company',
            onTap: () {
              // Navigate to About Us page or show company information
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'How can we help you?',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 10),
        Text(
          'Choose one of the options below to get the support you need.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildSupportOption(BuildContext context,
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: <Widget>[
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
