import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/data/porfolio_data.dart';
import 'package:porfolio/app/view/widget/scroll_reveal.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/contact_controller.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ContactController>();

    return ScrollReveal(
      delay: const Duration(milliseconds: 100),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.value<double>(
            context, mobile: 24, tablet: 60, desktop: 120,
          ),
          vertical: 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section heading ──────────────────────────
            _SectionHeading(),
            const SizedBox(height: 56),
      
            // ── Two column on desktop, stacked on mobile ─
            Responsive.isDesktop(context)
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: _ContactInfo()),
                      const SizedBox(width: 80),
                      Expanded(flex: 3, child: _ContactForm(ctrl: ctrl)),
                    ],
                  )
                : Column(
                    children: [
                      _ContactInfo(),
                      const SizedBox(height: 48),
                      _ContactForm(ctrl: ctrl),
                    ],
                  ),
      
            const SizedBox(height: 80),
      
            // ── Footer ───────────────────────────────────
            _Footer(),
          ],
        ),
      ),
    );
  }
}

// ── Section heading ────────────────────────────────────────
class _SectionHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Got a project in mind? Let\'s talk.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

// ── Left side contact info ─────────────────────────────────
class _ContactInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get in touch',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        Text(
          'I am currently open to new opportunities. '
          'Whether you have a question or just want to say hi, '
          'my inbox is always open!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),

        // Contact detail rows
        _ContactRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: PortfolioData.email,
          onTap: () => _launch('mailto:${PortfolioData.email}'),
        ),
        const SizedBox(height: 16),
        _ContactRow(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: 'github.com/yourhandle',
          onTap: () => _launch(PortfolioData.github),
        ),
        const SizedBox(height: 16),
        _ContactRow(
          icon: Icons.link_rounded,
          label: 'LinkedIn',
          value: 'linkedin.com/in/yourhandle',
          onTap: () => _launch(PortfolioData.linkedin),
        ),
      ],
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

// ── Single contact info row ────────────────────────────────
class _ContactRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  State<_ContactRow> createState() => _ContactRowState();
}

class _ContactRowState extends State<_ContactRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _hovered
                    ? AppTheme.primaryColor
                    : AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                size: 20,
                color: _hovered ? Colors.white : AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                  ),
                ),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _hovered
                        ? AppTheme.primaryColor
                        : Theme.of(context).textTheme.labelLarge?.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Contact form ───────────────────────────────────────────
class _ContactForm extends StatelessWidget {
  final ContactController ctrl;
  const _ContactForm({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: ctrl.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + Email row on desktop
          Responsive.isDesktop(context)
              ? Row(
                  children: [
                    Expanded(child: _NameField(ctrl: ctrl)),
                    const SizedBox(width: 16),
                    Expanded(child: _EmailField(ctrl: ctrl)),
                  ],
                )
              : Column(
                  children: [
                    _NameField(ctrl: ctrl),
                    const SizedBox(height: 16),
                    _EmailField(ctrl: ctrl),
                  ],
                ),

          const SizedBox(height: 16),
          _MessageField(ctrl: ctrl),
          const SizedBox(height: 24),
          _SubmitButton(ctrl: ctrl),
        ],
      ),
    );
  }
}

// ── Form fields ────────────────────────────────────────────
class _NameField extends StatelessWidget {
  final ContactController ctrl;
  const _NameField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl.nameCtrl,
      validator: ctrl.validateName,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(context, 'Your name', Icons.person_outline),
    );
  }
}

class _EmailField extends StatelessWidget {
  final ContactController ctrl;
  const _EmailField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl.emailCtrl,
      validator: ctrl.validateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _inputDecoration(context, 'Your email', Icons.email_outlined),
    );
  }
}

class _MessageField extends StatelessWidget {
  final ContactController ctrl;
  const _MessageField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: ctrl.messageCtrl,
      validator: ctrl.validateMessage,
      maxLines: 6,
      textInputAction: TextInputAction.newline,
      decoration: _inputDecoration(
        context, 'Your message', Icons.message_outlined,
      ),
    );
  }
}

// Shared input decoration
InputDecoration _inputDecoration(
  BuildContext context,
  String hint,
  IconData icon,
) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(icon, size: 20, color: AppTheme.primaryColor),
    hintStyle: TextStyle(
      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5),
      fontSize: 14,
    ),
    filled: true,
    fillColor: Theme.of(context).colorScheme.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).dividerColor.withOpacity(0.15),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Theme.of(context).dividerColor.withOpacity(0.15),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
  );
}

// ── Submit button ──────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final ContactController ctrl;
  const _SubmitButton({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final sending = ctrl.isSending.value;
      final sent    = ctrl.isSent.value;

      return SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: sending ? null : ctrl.submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: sent
                ? Colors.green
                : AppTheme.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: sending
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : sent
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('Message sent!',
                              style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Send message',
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
          ),
        ),
      );
    });
  }
}

// ── Footer ─────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: Theme.of(context).dividerColor.withOpacity(0.1)),
        const SizedBox(height: 24),
        Text(
          'Built with Flutter & GetX  ·  ${DateTime.now().year}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          PortfolioData.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}