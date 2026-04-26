class OnBoarding {
  final String title;
  final String image, description;

  OnBoarding({
    required this.title,
    required this.image,
    required this.description,
  });
}

List<OnBoarding> onboardingContents = [
  OnBoarding(
      title: 'Apprentissage pour tous',
      image: 'assets/images/onboarding_image_1.png',
      description:
          'Découvrez une application d\'apprentissage révolutionnaire conçue pour les parents, les enseignants et les élèves de tous âges et niveaux. Notre plateforme offre un accès illimité à une vaste collection de ressources éducatives de haute qualité, couvrant un large éventail de matières.'),
  OnBoarding(
      title: 'Des ressources pour chaque besoin',
      image: 'assets/images/onboarding_image_2.png',
      description:
          'Notre application propose une variété de contenus pédagogiques pour répondre aux besoins et aux intérêts de chaque apprenant. Trouvez des cours interactifs, des exercices pratiques, des vidéos éducatives, des jeux stimulants et bien plus encore.'),
  OnBoarding(
    title: 'Apprendre n\'a jamais été aussi facile',
    image: 'assets/images/onboarding_image_3.png',
    description:
        'Notre application conviviale et intuitive rend l\'apprentissage accessible à tous, où que vous soyez et quand vous le souhaitez. Profitez d\'une expérience d\'apprentissage personnalisée et adaptée à votre rythme.',
  ),
  OnBoarding(
      title: 'Rejoignez la communauté d\'apprentissage',
      image: 'assets/images/onboarding_image_4.png',
      description:
          'Connectez-vous avec d\'autres parents, enseignants et élèves du monde entier pour partager des idées, collaborer à des projets et vous entraider dans votre parcours d\'apprentissage.'),
];
