enum UserRoles {
  employee,
  employer,
}

class UserRolesHelper {
  static String getValue(UserRoles userRole) {
    switch (userRole) {
      case UserRoles.employee:
        return 'employee';
      case UserRoles.employer:
        return 'employer';
      default:
        return '';
    }
  }
}

enum CategoryExperience {
  trainee,
  junior,
  mid,
  senior,
}

class CategoryExperienceHelper {
  static String getValue(CategoryExperience userRole) {
    switch (userRole) {
      case CategoryExperience.trainee:
        return 'trainee';
      case CategoryExperience.junior:
        return 'junior';
      case CategoryExperience.mid:
        return 'mid';
      case CategoryExperience.senior:
        return 'senior';
      default:
        return '';
    }
  }
}

enum CategoryDegree {
  primarySchool,
  highScool,
  college,
  university,
}

class CategoryDegreeHelper {
  static String getValue(CategoryDegree userRole) {
    switch (userRole) {
      case CategoryDegree.primarySchool:
        return 'primary school';
      case CategoryDegree.highScool:
        return 'high scool';
      case CategoryDegree.college:
        return 'college';
      case CategoryDegree.university:
        return 'university';
      default:
        return '';
    }
  }
}

enum CategoryCompanySize {
  startup,
  smallcompany,
  corporation,
  bigcorporation,
  none,
}

class CategoryCompanySizeHelper {
  static String getValue(CategoryCompanySize userRole) {
    switch (userRole) {
      case CategoryCompanySize.startup:
        return 'startup';
      case CategoryCompanySize.smallcompany:
        return 'small company';
      case CategoryCompanySize.corporation:
        return 'corporation';
      case CategoryCompanySize.bigcorporation:
        return 'big corporation';
      case CategoryCompanySize.none:
        return '';
      default:
        return '';
    }
  }
}

enum CategoryTechnology {
  frontend,
  backend,
  fullstack,
  react,
  nodejs,
  js,
  css,
  html,
  flutter,
  dart,
}

class CategoryTechnologyHelper {
  static List<String> getValues() {
    List<String> avaiableTechs = [];
    for (var value in CategoryTechnology.values) {
      avaiableTechs.add(CategoryTechnologyHelper.getValue(value));
    }
    return avaiableTechs;
  }

  static String getValue(CategoryTechnology userRole) {
    switch (userRole) {
      case CategoryTechnology.frontend:
        return 'front-end';
      case CategoryTechnology.backend:
        return 'back-end';
      case CategoryTechnology.fullstack:
        return 'fullstack';
      case CategoryTechnology.react:
        return 'react';
      case CategoryTechnology.nodejs:
        return 'node-js';
      case CategoryTechnology.js:
        return 'js';
      case CategoryTechnology.css:
        return 'css';
      case CategoryTechnology.html:
        return 'html';
      case CategoryTechnology.flutter:
        return 'flutter';
      case CategoryTechnology.dart:
        return 'dart';
      default:
        return '';
    }
  }
}
