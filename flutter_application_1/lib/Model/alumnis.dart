  class Internship {
    final String year;
    final String entitled;
    final String description;
    final String type;
    final String city;
    final String postalCode;
    final String country;
    final String company;
    final String startDate;
    final String endDate;


    Internship({
      required this.year,
      required this.entitled,
      required this.type,
      required this.description,

      required this.city,
      required this.postalCode,
      required this.country,
      required this.company,
      required this.startDate,
      required this.endDate,
    });

    factory Internship.fromJson(Map<String, dynamic> json) {
      return Internship(
        year: json['annee']?.toString() ?? '',
        entitled: json['intitule']?.toString() ?? '',
        city: json['ville']?.toString() ?? '',
        postalCode: json['code_postal']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        type: json['entrepriseUniversite']?.toString() ?? 'I',
        country: json['pays']?.toString() ?? '',
        company: json['entreprise']?.toString() ?? '',
        startDate: json['debut']?.toString() ?? '',
        endDate: json['fin']?.toString() ?? '',
      );
    }
  }

  class Alumnis {
    final int id;
    final String lastName;
    final String firstname;
    final String email;
    final String phone;
    final int permission;
    final int deceased;
    final String gender;
    final String dateOfBirth;
    final int promotion;
    final String sector;
    final String formation;
    final String specialisation;
    final String option;
    final String doubleDiploma;

    final String job;
    final String jobDescription;
    final String jobStart;
    final String jobEnd;
    final String company;
    final String city;
    final String postalCode;
    final String country;

    final List<Internship> internships;

    Alumnis({
      required this.id,
      required this.lastName,
      required this.firstname,
      required this.email,
      required this.phone,
      required this.permission,
      required this.deceased,
      required this.gender,
      required this.dateOfBirth,
      required this.promotion,
      required this.sector,
      required this.formation,
      required this.specialisation,
      required this.option,
      required this.doubleDiploma,
      required this.job,
      required this.jobDescription,
      required this.jobStart,
      required this.jobEnd,
      required this.company,
      required this.city,
      required this.postalCode,
      required this.country,
      required this.internships,
    });

    String get wholeName => "${deceased == 1 ? "† " : ""}$firstname $lastName";

    factory Alumnis.fromMap(Map<String, dynamic> map) {
      var listStages = map['stages'] as List<dynamic>?;
      List<Internship> stagesList = listStages != null 
          ? listStages.map((i) => Internship.fromJson(i)).toList() 
          : [];

      return Alumnis(
        id: int.tryParse(map['id'].toString()) ?? 0,
        lastName: map['nom']?.toString() ?? '',
        firstname: map['prenom']?.toString() ?? '',  
        email: map['email']?.toString() ?? '',
        phone: map['tel']?.toString() ?? '',
        permission: int.tryParse(map['autor'].toString()) ?? 0,
        deceased: int.tryParse(map['decede'].toString()) ?? 0,
        gender: map['sexe']?.toString() ?? 'I',
        dateOfBirth: map['dateNaissance']?.toString() ?? "",
        promotion: int.tryParse(map['promo'].toString()) ?? 0,
        sector: map['filiere']?.toString() ?? '',
        formation: map['formation']?.toString() ?? '',
        specialisation: map['majeure']?.toString() ?? '',
        option: map['option']?.toString() ?? '',
        doubleDiploma: map['diplome']?.toString() ?? '',

        job: map['job']?.toString() ?? 'En recherche',
        jobDescription: map['job_desc']?.toString() ?? '',
        jobStart: map['job_debut']?.toString() ?? '', 
        jobEnd: map['job_fin']?.toString() ?? '',
        company: map['entreprise']?.toString() ?? 'Non renseigné',
        city: map['ville']?.toString() ?? '',
        postalCode: map['code_postal']?.toString() ?? '',
        country: map['pays']?.toString() ?? '',
        internships: stagesList,
      );
    }

    factory Alumnis.fromJson(Map<String, dynamic> json) => Alumnis.fromMap(json);
  }