class AppData {
  static const List<Map<String, dynamic>> genders = [
    {"label": "Male", "img": "assets/icons/male.png"},
    {"label": "Female", "img": "assets/icons/female.png"},
    {"label": "Transgender", "img": "assets/icons/transgender.png"},
    {"label": "Other", "img": "assets/icons/other.png"},
  ];

  static const List<Map<String, dynamic>> yourActivityList = [
    {
      "label": "Sedentary",
      "desc": "Little to no physical activity",
      "img": "assets/icons/Sedentary.png",
    },
    {
      "label": "Low Active",
      "desc": "Light activity 1–2 days a week",
      "img": "assets/icons/Low_Active.png",
    },
    {
      "label": "Active",
      "desc": "Exercise 3–5 days a week",
      "img": "assets/icons/Active.png",
    },
    {
      "label": "Very Active",
      "desc": "Intense training or physical job",
      "img": "assets/icons/Very_Active.png",
    },
  ];

  static const List<Map<String, dynamic>> yourClimateList = [
    {
      "label": "Hot",
      "desc": "You live in a warm or dry environment",
      "img": "assets/icons/Hot.png",
    },
    {
      "label": "Tropical",
      "desc": "Humid, sunny, and rainy climate",
      "img": "assets/icons/Tropical.png",
    },
    {
      "label": "Cold",
      "desc": "Cool or cold environment most of the year",
      "img": "assets/icons/Cold.png",
    },
  ];
}
