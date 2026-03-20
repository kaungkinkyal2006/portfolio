class PortfolioData {
  // ── Personal info ──────────────────────────────────────
  static const name        = 'Kaung Kin Kyal';
  static const title       = 'Software Developer';
  static const description =
      'I build beautiful, performant apps for mobile and web. '
      'Passionate about clean code, great UX, and solving real problems.';

  // These cycle in the animated typing effect
  static const typedStrings = [
    'Flutter Developer',
    'Mobile Engineer',
    'Frontend Developer',  
  ];

  static const email      = 'kaungkinkyal2006@gmail.com';
  static const github     = 'https://github.com/kaungkinkyal2006';
  static const linkedin   = 'https://linkedin.com/in/yourhandle';
  static const resumeUrl  = 'https://your-resume-link.com';

  // ── Skills (used in Phase 6) ───────────────────────────
  static const skills = <Map<String, dynamic>>[
    {'name': 'Flutter',    'level': 0.9,  'category': 'Mobile'},
    {'name': 'Dart',       'level': 0.85, 'category': 'Mobile'},
    {'name': 'GetX',       'level': 0.8,  'category': 'Mobile'},
    {'name': 'Firebase',   'level': 0.75, 'category': 'Backend'},
    {'name': 'REST APIs',  'level': 0.8,  'category': 'Backend'},
    {'name': 'Git',        'level': 0.85, 'category': 'Tools'},
    {'name': 'Figma',      'level': 0.7,  'category': 'Design'},
    {'name': 'HTML/CSS',   'level': 0.75, 'category': 'Web'},
  ];

  // ── Projects (used in Phase 7) ─────────────────────────
  static const projects = <Map<String, dynamic>>[
    {
      'title':       'E-Commerce App',
      'description': 'Full-featured shopping app with cart, payments, and order tracking.',
      'tags':        ['Flutter', 'Firebase', 'GetX'],
      'github':      'https://github.com/yourhandle/project1',
      'live':        'https://project1.com',
    },
    {
      'title':       'Weather App',
      'description': 'Real-time weather with beautiful animations and location support.',
      'tags':        ['Flutter', 'REST API', 'GetX'],
      'github':      'https://github.com/yourhandle/project2',
      'live':        '',
    },
    {
      'title':       'Portfolio Website',
      'description': 'This site! Built with Flutter Web and GetX.',
      'tags':        ['Flutter Web', 'GetX'],
      'github':      'https://github.com/yourhandle/portfolio',
      'live':        'https://yoursite.com',
    },
  ];
}