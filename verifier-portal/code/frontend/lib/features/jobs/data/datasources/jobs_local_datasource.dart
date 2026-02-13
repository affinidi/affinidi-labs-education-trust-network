import '../../domain/entities/job_opening.dart';

/// Mock data source for Nova Corp job listings
class JobsLocalDataSource {
  static final List<JobOpening> _mockJobs = [
    JobOpening(
      id: 'job-001',
      title: 'Senior Software Engineer',
      department: 'Engineering',
      location: 'Hong Kong',
      employmentType: 'Full-time',
      description:
          '''Nova Corp is seeking an experienced Senior Software Engineer to join our growing engineering team. You will be responsible for designing, developing, and maintaining scalable applications that power our digital identity platform.

This role offers the opportunity to work with cutting-edge technologies in decentralized identity, blockchain, and verifiable credentials. You'll collaborate with cross-functional teams to deliver innovative solutions that impact millions of users worldwide.''',
      responsibilities: [
        'Design and implement high-quality, scalable backend services',
        'Lead technical discussions and architectural decisions',
        'Mentor junior engineers and conduct code reviews',
        'Collaborate with product managers and designers',
        'Optimize application performance and reliability',
        'Contribute to technical documentation and best practices',
      ],
      requirements: [
        'Bachelor\'s degree in Computer Science or related field',
        '5+ years of professional software development experience',
        'Strong proficiency in Dart, Flutter, or similar modern frameworks',
        'Experience with distributed systems and microservices',
        'Solid understanding of RESTful APIs and web services',
        'Excellent problem-solving and communication skills',
      ],
      preferredQualifications: [
        'Experience with DIDComm or decentralized identity protocols',
        'Knowledge of blockchain technologies',
        'Contributions to open-source projects',
        'Experience with cloud platforms (AWS, GCP, Azure)',
      ],
      salaryRange: 'HKD 60,000 - 90,000 per month',
      postedDate: DateTime.now().subtract(const Duration(days: 7)),
      closingDate: DateTime.now().add(const Duration(days: 23)),
      isActive: true,
      applicantsCount: 24,
    ),
    JobOpening(
      id: 'job-002',
      title: 'Product Manager - Identity Solutions',
      department: 'Product',
      location: 'Hong Kong / Remote',
      employmentType: 'Full-time',
      description:
          '''We're looking for a strategic Product Manager to drive our identity solutions portfolio. You'll define product vision, roadmap, and success metrics while working closely with engineering, design, and business teams.

This is a unique opportunity to shape the future of digital identity and credentials management. You'll be at the forefront of emerging technologies including Self-Sovereign Identity (SSI) and verifiable credentials.''',
      responsibilities: [
        'Define and communicate product vision and strategy',
        'Develop and maintain product roadmaps',
        'Gather and analyze user feedback and market trends',
        'Work with engineering teams to prioritize features',
        'Create product requirements and user stories',
        'Monitor product metrics and drive continuous improvement',
        'Present product updates to stakeholders and executives',
      ],
      requirements: [
        'Bachelor\'s degree in Business, Computer Science, or related field',
        '4+ years of product management experience',
        'Strong analytical and problem-solving skills',
        'Excellent communication and stakeholder management',
        'Experience with agile development methodologies',
        'Proven track record of launching successful products',
      ],
      preferredQualifications: [
        'MBA or advanced degree',
        'Experience in identity or security products',
        'Understanding of blockchain and decentralized technologies',
        'Technical background or engineering experience',
      ],
      salaryRange: 'HKD 55,000 - 80,000 per month',
      postedDate: DateTime.now().subtract(const Duration(days: 5)),
      closingDate: DateTime.now().add(const Duration(days: 25)),
      isActive: true,
      applicantsCount: 18,
    ),
    JobOpening(
      id: 'job-003',
      title: 'UX/UI Designer',
      department: 'Design',
      location: 'Hong Kong',
      employmentType: 'Full-time',
      description:
          '''Nova Corp is seeking a talented UX/UI Designer to create intuitive and delightful user experiences for our digital identity products. You'll work on mobile and web applications that millions of users interact with daily.

Join our design team to shape how people manage and share their digital credentials. You'll have the opportunity to work on complex problems in the identity space while maintaining a focus on simplicity and user-centricity.''',
      responsibilities: [
        'Design user interfaces for web and mobile applications',
        'Create wireframes, prototypes, and high-fidelity mockups',
        'Conduct user research and usability testing',
        'Collaborate with product managers and engineers',
        'Maintain and evolve the design system',
        'Advocate for user-centered design principles',
      ],
      requirements: [
        'Bachelor\'s degree in Design, HCI, or related field',
        '3+ years of UX/UI design experience',
        'Proficiency in Figma, Sketch, or similar design tools',
        'Strong portfolio demonstrating design process and outcomes',
        'Understanding of mobile and web design patterns',
        'Excellent visual design and typography skills',
      ],
      preferredQualifications: [
        'Experience designing financial or security applications',
        'Knowledge of accessibility standards (WCAG)',
        'Prototyping skills with tools like Principle or ProtoPie',
        'Basic understanding of HTML/CSS',
      ],
      salaryRange: 'HKD 40,000 - 60,000 per month',
      postedDate: DateTime.now().subtract(const Duration(days: 3)),
      closingDate: DateTime.now().add(const Duration(days: 27)),
      isActive: true,
      applicantsCount: 31,
    ),
    JobOpening(
      id: 'job-004',
      title: 'DevOps Engineer',
      department: 'Engineering',
      location: 'Hong Kong',
      employmentType: 'Full-time',
      description:
          '''We're seeking a skilled DevOps Engineer to build and maintain our cloud infrastructure. You'll work on automation, CI/CD pipelines, and ensuring our services are highly available and performant.

This role is perfect for someone passionate about infrastructure-as-code, containerization, and continuous delivery. You'll have the freedom to choose the right tools and architect scalable solutions.''',
      responsibilities: [
        'Design and maintain cloud infrastructure (AWS/GCP)',
        'Build and optimize CI/CD pipelines',
        'Implement monitoring, logging, and alerting systems',
        'Automate deployment and operational processes',
        'Ensure security best practices across infrastructure',
        'Troubleshoot production issues and improve reliability',
      ],
      requirements: [
        'Bachelor\'s degree in Computer Science or related field',
        '3+ years of DevOps or SRE experience',
        'Strong experience with Docker and Kubernetes',
        'Proficiency in scripting (Python, Bash, etc.)',
        'Experience with Infrastructure as Code (Terraform, CloudFormation)',
        'Understanding of networking and security principles',
      ],
      preferredQualifications: [
        'AWS or GCP certifications',
        'Experience with service mesh (Istio, Linkerd)',
        'Knowledge of observability tools (Prometheus, Grafana)',
        'Experience with distributed systems',
      ],
      salaryRange: 'HKD 50,000 - 75,000 per month',
      postedDate: DateTime.now().subtract(const Duration(days: 10)),
      closingDate: DateTime.now().add(const Duration(days: 20)),
      isActive: true,
      applicantsCount: 15,
    ),
    JobOpening(
      id: 'job-005',
      title: 'Business Development Manager',
      department: 'Business Development',
      location: 'Hong Kong / Singapore',
      employmentType: 'Full-time',
      description:
          '''Nova Corp is expanding rapidly across Asia-Pacific, and we need a dynamic Business Development Manager to drive our growth. You'll identify new business opportunities, build strategic partnerships, and help establish Nova Corp as a leader in the digital identity space.

This role requires someone who can navigate complex B2B relationships, understand technical products, and close deals. You'll work directly with C-level executives and key decision-makers.''',
      responsibilities: [
        'Identify and pursue new business opportunities',
        'Build and maintain strategic partnerships',
        'Develop go-to-market strategies for new regions',
        'Negotiate contracts and close deals',
        'Collaborate with product and engineering teams',
        'Represent Nova Corp at industry events and conferences',
        'Track and report on sales metrics and pipeline',
      ],
      requirements: [
        'Bachelor\'s degree in Business, Marketing, or related field',
        '5+ years of B2B sales or business development experience',
        'Proven track record of meeting or exceeding sales targets',
        'Excellent negotiation and presentation skills',
        'Strong network in technology or financial services',
        'Fluency in English and Chinese (Mandarin/Cantonese)',
      ],
      preferredQualifications: [
        'Experience in SaaS or enterprise software sales',
        'Understanding of blockchain or identity technologies',
        'MBA or advanced degree',
        'Experience in APAC markets',
      ],
      salaryRange: 'HKD 50,000 - 80,000 per month + Commission',
      postedDate: DateTime.now().subtract(const Duration(days: 14)),
      closingDate: DateTime.now().add(const Duration(days: 16)),
      isActive: true,
      applicantsCount: 22,
    ),
    JobOpening(
      id: 'job-006',
      title: 'Data Scientist',
      department: 'Data & Analytics',
      location: 'Hong Kong',
      employmentType: 'Full-time',
      description:
          '''Join our data team to extract insights from millions of credential transactions and user interactions. You'll build machine learning models, create data pipelines, and help us make data-driven product decisions.

This is an opportunity to work with unique datasets in the identity space and apply advanced analytics to improve fraud detection, user experience, and business outcomes.''',
      responsibilities: [
        'Develop and deploy machine learning models',
        'Analyze large datasets to extract actionable insights',
        'Build data pipelines and ETL processes',
        'Create dashboards and visualizations for stakeholders',
        'Collaborate with product teams on data-driven features',
        'Conduct A/B tests and statistical analysis',
      ],
      requirements: [
        'Master\'s degree in Computer Science, Statistics, or related field',
        '3+ years of data science or machine learning experience',
        'Strong proficiency in Python and SQL',
        'Experience with ML frameworks (TensorFlow, PyTorch, Scikit-learn)',
        'Solid understanding of statistics and experimental design',
        'Excellent communication skills to explain complex findings',
      ],
      preferredQualifications: [
        'PhD in a quantitative field',
        'Experience with big data technologies (Spark, Hadoop)',
        'Knowledge of fraud detection or anomaly detection',
        'Publications or contributions to ML community',
      ],
      salaryRange: 'HKD 55,000 - 85,000 per month',
      postedDate: DateTime.now().subtract(const Duration(days: 12)),
      closingDate: DateTime.now().add(const Duration(days: 18)),
      isActive: true,
      applicantsCount: 19,
    ),
  ];

  Future<List<JobOpening>> getAllJobs() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockJobs;
  }

  Future<JobOpening?> getJobById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockJobs.firstWhere((job) => job.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<JobOpening>> searchJobs(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final lowerQuery = query.toLowerCase();
    return _mockJobs.where((job) {
      return job.title.toLowerCase().contains(lowerQuery) ||
          job.department.toLowerCase().contains(lowerQuery) ||
          job.description.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
