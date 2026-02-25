// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get sectionRecherchesStages => '';

  @override
  String get deleteOfferTitle => 'Supprimer l\'offre ?';

  @override
  String get deleteOfferContent => 'Cette action est irréversible.';

  @override
  String get cancel => 'Annuler';

  @override
  String get offerDeletedSuccess => 'Offre supprimée';

  @override
  String get offerDeletedError => 'Erreur lors de la suppression';

  @override
  String get deleteBtn => 'Supprimer';

  @override
  String get careersStagesTitle => 'Carrières & Stages';

  @override
  String get searchOfferHint => 'Rechercher (Poste, Entreprise...)';

  @override
  String get jobOffersTitle => 'Offres d\'Emploi';

  @override
  String get internshipOffersTitle => 'Offres de Stage';

  @override
  String get noOfferFound => 'Aucune offre trouvée';

  @override
  String get defaultJobTitle => 'Poste';

  @override
  String get byPrefix => 'Par : ';

  @override
  String get addInternship => 'Ajouter un Stage';

  @override
  String get addJob => 'Ajouter un Emploi';

  @override
  String get atLocation => ' à ';

  @override
  String get descriptionLabel => 'Description :';

  @override
  String get descriptionField => 'Description';

  @override
  String get noDescription => 'Aucune description';

  @override
  String get contactLabel => 'Contact :';

  @override
  String get close => 'Fermer';

  @override
  String get newInternship => 'Nouveau Stage';

  @override
  String get newJob => 'Nouvel Emploi';

  @override
  String get jobTitleLabel => 'Intitulé du poste';

  @override
  String get companyLabel => 'Entreprise';

  @override
  String get cityLabel => 'Ville';

  @override
  String get typeLabel => 'Type';

  @override
  String get contactEmailLabel => 'Email contact';

  @override
  String get publish => 'Publier';

  @override
  String get sectionAnnuaireEntreprises => '';

  @override
  String get companiesDirectory => 'Annuaire des Entreprises';

  @override
  String get unknownCompany => 'Inconnu';

  @override
  String get alumniLabel => 'alumni';

  @override
  String get sectionLogin => '';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailRequired => 'Email requis';

  @override
  String get loginInvalidEmail => 'Email invalide';

  @override
  String get loginPasswordLabel => 'Mot de passe';

  @override
  String get loginPasswordRequired => 'Entrez un mot de passe';

  @override
  String get loginPasswordTooShort => 'Mot de passe trop court';

  @override
  String get loginForgetPassword => 'Mot de passe oublié ?';

  @override
  String get loginSubmitButton => 'SE CONNECTER';

  @override
  String get loginOrDivider => 'OU';

  @override
  String get loginMicrosoftButton => 'Se connecter avec Microsoft 365';

  @override
  String get loginErrorConnection => 'Connexion Impossible !';

  @override
  String get loginErrorUnknown => 'Erreur inconnue';

  @override
  String get sectionProfile => '';

  @override
  String get profileTitle => 'Mon Profil';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Téléphone';

  @override
  String get profileSecurity => 'Sécurité';

  @override
  String get profileModifyPassword => 'Modifier mon mot de passe';

  @override
  String get profileLogout => 'Se déconnecter';

  @override
  String get modifyPassword => 'Modifier le mot de passe';

  @override
  String get lastPassword => 'Ancien mot de passe';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmNewPassword => 'Confirmer le nouveau mot de passe';

  @override
  String get required => 'Requis';

  @override
  String get minCharacters => 'Minimum 6 caractères';

  @override
  String get passwordsDoNotMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordChangedSuccess => 'Mot de passe modifié avec succès';

  @override
  String get passwordChangedError =>
      'Erreur : Impossible de modifier le mot de passe';

  @override
  String get unknownUser => 'Utilisateur';

  @override
  String get validate => 'Valider';

  @override
  String get sectionDirectory => '';

  @override
  String get directoryNoResult => 'Aucun résultat';

  @override
  String get directorySearchHint => 'Recherche...';

  @override
  String get directorySelectStudent => 'Sélectionnez un élève';

  @override
  String get directoryNewAlumniTitle => 'Nouvel Alumni';

  @override
  String get directoryDeleteConfirmTitle => 'Supprimer ?';

  @override
  String directoryDeleteConfirmContent(Object name) {
    return 'Voulez-vous supprimer $name ?';
  }

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get directoryHistoryTitle => 'Historique';

  @override
  String get directoryHistoryEmpty => 'Aucune action enregistrée.';

  @override
  String get directoryOnDate => 'le';

  @override
  String get directoryActionDelete => 'SUPPRESSION';

  @override
  String get directoryActionAdd => 'AJOUT';

  @override
  String get sectionPreview => '';

  @override
  String get previewInternships => 'Stages :';

  @override
  String get previewSeeFullProfile => 'Voir la fiche complète';

  @override
  String get sectionDetail => '';

  @override
  String get detailEditTitle => 'Modifier Alumni';

  @override
  String detailAge(String years) {
    return '$years ans';
  }

  @override
  String get detailLabelFirstName => 'Prénom';

  @override
  String get detailLabelLastName => 'Nom';

  @override
  String get detailLabelPromo => 'Promo (Année)';

  @override
  String get detailLabelBirthDate => 'Date de Naissance';

  @override
  String get detailAdminStatus => 'Statut Administrateur';

  @override
  String get detailPermissionData => 'Autorisation des données';

  @override
  String get detailVisible => 'Visible';

  @override
  String get detailHidden => 'Caché';

  @override
  String get detailDeceased => 'Décédé';

  @override
  String get detailDeceasedSubtitle => 'Marquer comme décédé';

  @override
  String get detailInfoStudies => 'Études';

  @override
  String get detailLabelSector => 'Filière';

  @override
  String get detailLabelSpecialisation => 'Majeure';

  @override
  String get detailLabelOption => 'Option';

  @override
  String get detailLabelDoubleDiploma => 'Double Diplôme';

  @override
  String get detailInfoPro => 'Infos Pro';

  @override
  String get detailLabelJob => 'Poste';

  @override
  String get detailLabelJobDesc => 'Description du poste';

  @override
  String get detailLabelCity => 'Ville';

  @override
  String get detailLabelCompany => 'Entreprise';

  @override
  String get detailLabelSeniority => 'Ancienneté';

  @override
  String get detailLabelStartDate => 'Date de début (Poste)';

  @override
  String get detailContactHidden => 'Coordonnées masquées';

  @override
  String get detailInternshipTitle => 'Stages';

  @override
  String get detailInternshipAdd => 'Ajouter';

  @override
  String get detailInternshipNone => 'Aucun stage renseigné';

  @override
  String get detailInternshipUniversity => 'Université';

  @override
  String get detailInternshipCompany => 'Entreprise';

  @override
  String get detailInternshipLocation => 'Lieu';

  @override
  String get detailInternshipPeriod => 'Période';

  @override
  String get detailInternshipDescription => 'Description';

  @override
  String get detailLabelCountry => 'Pays';

  @override
  String get detailLabelDescription => 'Description';

  @override
  String get sectionForm => '';

  @override
  String get formIdentityTitle => 'Identité';

  @override
  String get formRequired => 'Requis';

  @override
  String get formGenderUnknown => 'Inconnu';

  @override
  String get formGenderMale => 'Homme';

  @override
  String get formGenderFemale => 'Femme';

  @override
  String get formConsent =>
      'Consentir à ce que le téléphone et le mail soient visibles';

  @override
  String get formFormationTitle => 'Formation ENSI';

  @override
  String get formPromoHint => 'Promo (ex: 2024) *';

  @override
  String get formFormationFISE => 'FISE (Etudiant)';

  @override
  String get formFormationFISA => 'FISA (Alternance)';

  @override
  String get formFormationMTS => 'MTS (Mastère)';

  @override
  String get formJobTitle => 'Poste Actuel';

  @override
  String get formInternshipsTitle => 'Stages';

  @override
  String get formNoInternship => 'Aucun stage ajouté (facultatif)';

  @override
  String get formInternshipYear => 'Année du stage';

  @override
  String get formInternship1A => '1ère Année (1A)';

  @override
  String get formInternship2A => '2ème Année (2A)';

  @override
  String get formInternship3A => 'PFE (3A)';

  @override
  String get formInternshipSubject => 'Sujet / Intitulé *';

  @override
  String get formInternshipStructureReq => 'Type de structure requis';

  @override
  String get formInternshipLab => 'Nom de l\'Entreprise / du Labo';

  @override
  String get formAdminRejectTitle => 'Refuser la demande ?';

  @override
  String get formAdminRejectContent => 'Cette action est irréversible.';

  @override
  String get formAdminRejectConfirm => 'Confirmer le refus';

  @override
  String get formAdminRejectButton => 'REFUSER CETTE DEMANDE';

  @override
  String get formSaveLoading => 'Enregistrement...';

  @override
  String get formSaveButton => 'Enregistrer l\'Alumni';

  @override
  String get formMsgAdded => 'Alumni ajouté directement !';

  @override
  String get formMsgPending => 'Demande envoyée pour validation.';

  @override
  String formMsgError(String error) {
    return 'Erreur : $error';
  }
}
