import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @sectionCommun.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionCommun;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @deleteBtn.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get deleteBtn;

  /// No description provided for @publish.
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get publish;

  /// No description provided for @yes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get no;

  /// No description provided for @required.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get required;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @backBtn.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get backBtn;

  /// No description provided for @reloadBtn.
  ///
  /// In fr, this message translates to:
  /// **'Recharger'**
  String get reloadBtn;

  /// No description provided for @untitled.
  ///
  /// In fr, this message translates to:
  /// **'Sans titre'**
  String get untitled;

  /// No description provided for @sectionNavigation.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionNavigation;

  /// No description provided for @homeTab.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeTab;

  /// No description provided for @eventsTab.
  ///
  /// In fr, this message translates to:
  /// **'Évènements'**
  String get eventsTab;

  /// No description provided for @drawerMenu.
  ///
  /// In fr, this message translates to:
  /// **'Menu'**
  String get drawerMenu;

  /// No description provided for @drawerNews.
  ///
  /// In fr, this message translates to:
  /// **'Actualités'**
  String get drawerNews;

  /// No description provided for @drawerDirectory.
  ///
  /// In fr, this message translates to:
  /// **'Annuaire'**
  String get drawerDirectory;

  /// No description provided for @drawerOffers.
  ///
  /// In fr, this message translates to:
  /// **'Offres'**
  String get drawerOffers;

  /// No description provided for @drawerSchoolSite.
  ///
  /// In fr, this message translates to:
  /// **'Site École'**
  String get drawerSchoolSite;

  /// No description provided for @drawerProposeEvent.
  ///
  /// In fr, this message translates to:
  /// **'Proposer un évènement'**
  String get drawerProposeEvent;

  /// No description provided for @drawerJoin.
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get drawerJoin;

  /// No description provided for @drawerModeration.
  ///
  /// In fr, this message translates to:
  /// **'Modération'**
  String get drawerModeration;

  /// No description provided for @sectionRecherchesStages.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionRecherchesStages;

  /// No description provided for @careersStagesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Carrières & Stages'**
  String get careersStagesTitle;

  /// No description provided for @searchOfferHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher (Poste, Entreprise...)'**
  String get searchOfferHint;

  /// No description provided for @jobOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offres d\'Emploi'**
  String get jobOffersTitle;

  /// No description provided for @internshipOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offres de Stage'**
  String get internshipOffersTitle;

  /// No description provided for @noOfferFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucune offre trouvée'**
  String get noOfferFound;

  /// No description provided for @defaultJobTitle.
  ///
  /// In fr, this message translates to:
  /// **'Poste'**
  String get defaultJobTitle;

  /// No description provided for @byPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Par : '**
  String get byPrefix;

  /// No description provided for @addInternship.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un Stage'**
  String get addInternship;

  /// No description provided for @addJob.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un Emploi'**
  String get addJob;

  /// No description provided for @atLocation.
  ///
  /// In fr, this message translates to:
  /// **' à '**
  String get atLocation;

  /// No description provided for @descriptionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Description :'**
  String get descriptionLabel;

  /// No description provided for @descriptionField.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get descriptionField;

  /// No description provided for @noDescription.
  ///
  /// In fr, this message translates to:
  /// **'Aucune description'**
  String get noDescription;

  /// No description provided for @contactLabel.
  ///
  /// In fr, this message translates to:
  /// **'Contact :'**
  String get contactLabel;

  /// No description provided for @newInternship.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau Stage'**
  String get newInternship;

  /// No description provided for @newJob.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Emploi'**
  String get newJob;

  /// No description provided for @jobTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Intitulé du poste'**
  String get jobTitleLabel;

  /// No description provided for @companyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get companyLabel;

  /// No description provided for @cityLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get cityLabel;

  /// No description provided for @typeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type : '**
  String get typeLabel;

  /// No description provided for @contactEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email contact'**
  String get contactEmailLabel;

  /// No description provided for @deleteOfferTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'offre ?'**
  String get deleteOfferTitle;

  /// No description provided for @deleteOfferContent.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get deleteOfferContent;

  /// No description provided for @offerDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Offre supprimée'**
  String get offerDeletedSuccess;

  /// No description provided for @offerDeletedError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de la suppression'**
  String get offerDeletedError;

  /// No description provided for @seeAllOffers.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes les offres'**
  String get seeAllOffers;

  /// No description provided for @sectionAnnuaireEntreprises.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionAnnuaireEntreprises;

  /// No description provided for @companiesDirectory.
  ///
  /// In fr, this message translates to:
  /// **'Annuaire des Entreprises'**
  String get companiesDirectory;

  /// No description provided for @unknownCompany.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get unknownCompany;

  /// No description provided for @alumniLabel.
  ///
  /// In fr, this message translates to:
  /// **'alumni'**
  String get alumniLabel;

  /// No description provided for @companiesFilterCompany.
  ///
  /// In fr, this message translates to:
  /// **'Par Entreprise'**
  String get companiesFilterCompany;

  /// No description provided for @companiesFilterCity.
  ///
  /// In fr, this message translates to:
  /// **'Par Ville'**
  String get companiesFilterCity;

  /// No description provided for @sectionLogin.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionLogin;

  /// No description provided for @loginEmailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get loginEmailLabel;

  /// No description provided for @loginEmailRequired.
  ///
  /// In fr, this message translates to:
  /// **'Email requis'**
  String get loginEmailRequired;

  /// No description provided for @loginInvalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email invalide'**
  String get loginInvalidEmail;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get loginPasswordLabel;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Entrez un mot de passe'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe trop court'**
  String get loginPasswordTooShort;

  /// No description provided for @loginForgetPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get loginForgetPassword;

  /// No description provided for @loginSubmitButton.
  ///
  /// In fr, this message translates to:
  /// **'SE CONNECTER'**
  String get loginSubmitButton;

  /// No description provided for @loginOrDivider.
  ///
  /// In fr, this message translates to:
  /// **'OU'**
  String get loginOrDivider;

  /// No description provided for @loginMicrosoftButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter avec Microsoft 365'**
  String get loginMicrosoftButton;

  /// No description provided for @loginErrorConnection.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Impossible !'**
  String get loginErrorConnection;

  /// No description provided for @loginErrorUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inconnue'**
  String get loginErrorUnknown;

  /// No description provided for @sectionProfile.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionProfile;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon Profil'**
  String get profileTitle;

  /// No description provided for @profileEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get profilePhone;

  /// No description provided for @profileSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité'**
  String get profileSecurity;

  /// No description provided for @profileModifyPassword.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon mot de passe'**
  String get profileModifyPassword;

  /// No description provided for @profileLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get profileLogout;

  /// No description provided for @modifyPassword.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le mot de passe'**
  String get modifyPassword;

  /// No description provided for @lastPassword.
  ///
  /// In fr, this message translates to:
  /// **'Ancien mot de passe'**
  String get lastPassword;

  /// No description provided for @newPassword.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le nouveau mot de passe'**
  String get confirmNewPassword;

  /// No description provided for @minCharacters.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 6 caractères'**
  String get minCharacters;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe modifié avec succès'**
  String get passwordChangedSuccess;

  /// No description provided for @passwordChangedError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : Impossible de modifier le mot de passe'**
  String get passwordChangedError;

  /// No description provided for @unknownUser.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur'**
  String get unknownUser;

  /// No description provided for @sectionDirectory.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionDirectory;

  /// No description provided for @directoryNoResult.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get directoryNoResult;

  /// No description provided for @directorySearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Recherche...'**
  String get directorySearchHint;

  /// No description provided for @directorySelectStudent.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez un élève'**
  String get directorySelectStudent;

  /// No description provided for @directoryNewAlumniTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Alumni'**
  String get directoryNewAlumniTitle;

  /// No description provided for @directoryDeleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer ?'**
  String get directoryDeleteConfirmTitle;

  /// No description provided for @directoryDeleteConfirmContent.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous supprimer {name} ?'**
  String directoryDeleteConfirmContent(Object name);

  /// No description provided for @directoryHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get directoryHistoryTitle;

  /// No description provided for @directoryHistoryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune action enregistrée.'**
  String get directoryHistoryEmpty;

  /// No description provided for @directoryOnDate.
  ///
  /// In fr, this message translates to:
  /// **'le'**
  String get directoryOnDate;

  /// No description provided for @directoryActionDelete.
  ///
  /// In fr, this message translates to:
  /// **'SUPPRESSION'**
  String get directoryActionDelete;

  /// No description provided for @directoryActionAdd.
  ///
  /// In fr, this message translates to:
  /// **'AJOUT'**
  String get directoryActionAdd;

  /// No description provided for @sectionPreview.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionPreview;

  /// No description provided for @previewInternships.
  ///
  /// In fr, this message translates to:
  /// **'Stages :'**
  String get previewInternships;

  /// No description provided for @previewSeeFullProfile.
  ///
  /// In fr, this message translates to:
  /// **'Voir la fiche complète'**
  String get previewSeeFullProfile;

  /// No description provided for @sectionDetail.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionDetail;

  /// No description provided for @detailEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier Alumni'**
  String get detailEditTitle;

  /// Âge calculé de l'alumni
  ///
  /// In fr, this message translates to:
  /// **'{years} ans'**
  String detailAge(String years);

  /// No description provided for @detailLabelFirstName.
  ///
  /// In fr, this message translates to:
  /// **'Prénom'**
  String get detailLabelFirstName;

  /// No description provided for @detailLabelLastName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get detailLabelLastName;

  /// No description provided for @detailLabelPromo.
  ///
  /// In fr, this message translates to:
  /// **'Promo (Année)'**
  String get detailLabelPromo;

  /// No description provided for @detailLabelBirthDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de Naissance'**
  String get detailLabelBirthDate;

  /// No description provided for @detailAdminStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut Administrateur'**
  String get detailAdminStatus;

  /// No description provided for @detailPermissionData.
  ///
  /// In fr, this message translates to:
  /// **'Autorisation des données'**
  String get detailPermissionData;

  /// No description provided for @detailVisible.
  ///
  /// In fr, this message translates to:
  /// **'Visible'**
  String get detailVisible;

  /// No description provided for @detailHidden.
  ///
  /// In fr, this message translates to:
  /// **'Caché'**
  String get detailHidden;

  /// No description provided for @detailDeceased.
  ///
  /// In fr, this message translates to:
  /// **'Décédé'**
  String get detailDeceased;

  /// No description provided for @detailDeceasedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme décédé'**
  String get detailDeceasedSubtitle;

  /// No description provided for @detailInfoStudies.
  ///
  /// In fr, this message translates to:
  /// **'Études'**
  String get detailInfoStudies;

  /// No description provided for @detailLabelSector.
  ///
  /// In fr, this message translates to:
  /// **'Filière'**
  String get detailLabelSector;

  /// No description provided for @detailLabelSpecialisation.
  ///
  /// In fr, this message translates to:
  /// **'Majeure'**
  String get detailLabelSpecialisation;

  /// No description provided for @detailLabelOption.
  ///
  /// In fr, this message translates to:
  /// **'Option'**
  String get detailLabelOption;

  /// No description provided for @detailLabelDoubleDiploma.
  ///
  /// In fr, this message translates to:
  /// **'Double Diplôme'**
  String get detailLabelDoubleDiploma;

  /// No description provided for @detailInfoPro.
  ///
  /// In fr, this message translates to:
  /// **'Infos Pro'**
  String get detailInfoPro;

  /// No description provided for @detailLabelJob.
  ///
  /// In fr, this message translates to:
  /// **'Poste'**
  String get detailLabelJob;

  /// No description provided for @detailLabelJobDesc.
  ///
  /// In fr, this message translates to:
  /// **'Description du poste'**
  String get detailLabelJobDesc;

  /// No description provided for @detailLabelCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get detailLabelCity;

  /// No description provided for @detailLabelPostalCode.
  ///
  /// In fr, this message translates to:
  /// **'Code Postal'**
  String get detailLabelPostalCode;

  /// No description provided for @detailLabelCompany.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get detailLabelCompany;

  /// No description provided for @detailLabelSeniority.
  ///
  /// In fr, this message translates to:
  /// **'Ancienneté'**
  String get detailLabelSeniority;

  /// No description provided for @detailLabelStartDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de début (Poste)'**
  String get detailLabelStartDate;

  /// No description provided for @detailContactHidden.
  ///
  /// In fr, this message translates to:
  /// **'Coordonnées masquées'**
  String get detailContactHidden;

  /// No description provided for @detailInternshipTitle.
  ///
  /// In fr, this message translates to:
  /// **'Stages'**
  String get detailInternshipTitle;

  /// No description provided for @detailInternshipAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get detailInternshipAdd;

  /// No description provided for @detailInternshipNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun stage renseigné'**
  String get detailInternshipNone;

  /// No description provided for @detailInternshipUniversity.
  ///
  /// In fr, this message translates to:
  /// **'Université'**
  String get detailInternshipUniversity;

  /// No description provided for @detailInternshipCompany.
  ///
  /// In fr, this message translates to:
  /// **'Entreprise'**
  String get detailInternshipCompany;

  /// No description provided for @detailInternshipLocation.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get detailInternshipLocation;

  /// No description provided for @detailInternshipPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get detailInternshipPeriod;

  /// No description provided for @detailInternshipDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get detailInternshipDescription;

  /// No description provided for @detailLabelCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get detailLabelCountry;

  /// No description provided for @detailLabelDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get detailLabelDescription;

  /// No description provided for @sectionForm.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionForm;

  /// No description provided for @formIdentityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Identité'**
  String get formIdentityTitle;

  /// No description provided for @formRequired.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get formRequired;

  /// No description provided for @formGenderUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Inconnu'**
  String get formGenderUnknown;

  /// No description provided for @formGenderMale.
  ///
  /// In fr, this message translates to:
  /// **'Homme'**
  String get formGenderMale;

  /// No description provided for @formGenderFemale.
  ///
  /// In fr, this message translates to:
  /// **'Femme'**
  String get formGenderFemale;

  /// No description provided for @formConsent.
  ///
  /// In fr, this message translates to:
  /// **'Consentir à ce que le téléphone et le mail soient visibles'**
  String get formConsent;

  /// No description provided for @formFormationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Formation ENSI'**
  String get formFormationTitle;

  /// No description provided for @formPromoHint.
  ///
  /// In fr, this message translates to:
  /// **'Promo (ex: 2024) *'**
  String get formPromoHint;

  /// No description provided for @formFormationFISE.
  ///
  /// In fr, this message translates to:
  /// **'FISE (Etudiant)'**
  String get formFormationFISE;

  /// No description provided for @formFormationFISA.
  ///
  /// In fr, this message translates to:
  /// **'FISA (Alternance)'**
  String get formFormationFISA;

  /// No description provided for @formFormationMTS.
  ///
  /// In fr, this message translates to:
  /// **'MTS (Mastère)'**
  String get formFormationMTS;

  /// No description provided for @formJobTitle.
  ///
  /// In fr, this message translates to:
  /// **'Poste Actuel'**
  String get formJobTitle;

  /// No description provided for @formInternshipsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Stages'**
  String get formInternshipsTitle;

  /// No description provided for @formNoInternship.
  ///
  /// In fr, this message translates to:
  /// **'Aucun stage ajouté (facultatif)'**
  String get formNoInternship;

  /// No description provided for @formInternshipYear.
  ///
  /// In fr, this message translates to:
  /// **'Année du stage'**
  String get formInternshipYear;

  /// No description provided for @formInternship1A.
  ///
  /// In fr, this message translates to:
  /// **'1ère Année (1A)'**
  String get formInternship1A;

  /// No description provided for @formInternship2A.
  ///
  /// In fr, this message translates to:
  /// **'2ème Année (2A)'**
  String get formInternship2A;

  /// No description provided for @formInternship3A.
  ///
  /// In fr, this message translates to:
  /// **'PFE (3A)'**
  String get formInternship3A;

  /// No description provided for @formInternshipSubject.
  ///
  /// In fr, this message translates to:
  /// **'Sujet / Intitulé *'**
  String get formInternshipSubject;

  /// No description provided for @formInternshipStructureReq.
  ///
  /// In fr, this message translates to:
  /// **'Type de structure requis'**
  String get formInternshipStructureReq;

  /// No description provided for @formInternshipLab.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'Entreprise / du Labo'**
  String get formInternshipLab;

  /// No description provided for @formAdminRejectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Refuser la demande ?'**
  String get formAdminRejectTitle;

  /// No description provided for @formAdminRejectContent.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible.'**
  String get formAdminRejectContent;

  /// No description provided for @formAdminRejectConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le refus'**
  String get formAdminRejectConfirm;

  /// No description provided for @formAdminRejectButton.
  ///
  /// In fr, this message translates to:
  /// **'REFUSER CETTE DEMANDE'**
  String get formAdminRejectButton;

  /// No description provided for @formSaveLoading.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement...'**
  String get formSaveLoading;

  /// No description provided for @formSaveButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer l\'Alumni'**
  String get formSaveButton;

  /// No description provided for @formMsgAdded.
  ///
  /// In fr, this message translates to:
  /// **'Alumni ajouté directement !'**
  String get formMsgAdded;

  /// No description provided for @formMsgPending.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée pour validation.'**
  String get formMsgPending;

  /// No description provided for @formMsgError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur : {error}'**
  String formMsgError(String error);

  /// No description provided for @sectionWidgetsAndDialogs.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionWidgetsAndDialogs;

  /// No description provided for @dialogLoginRequiredNews.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez vous connecter pour publier une actualité.'**
  String get dialogLoginRequiredNews;

  /// No description provided for @dialogNewNews.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle Actualité'**
  String get dialogNewNews;

  /// No description provided for @dialogTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get dialogTitleLabel;

  /// No description provided for @dialogImageUrlLabel.
  ///
  /// In fr, this message translates to:
  /// **'URL Image (optionnel)'**
  String get dialogImageUrlLabel;

  /// No description provided for @dialogNewEvent.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Évènement'**
  String get dialogNewEvent;

  /// No description provided for @dialogLocationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lieu'**
  String get dialogLocationLabel;

  /// No description provided for @dialogDateTimeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date et heure'**
  String get dialogDateTimeLabel;

  /// No description provided for @addNewsTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une actualité'**
  String get addNewsTooltip;

  /// No description provided for @noNewsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune actualité.'**
  String get noNewsAvailable;

  /// No description provided for @seeAllNews.
  ///
  /// In fr, this message translates to:
  /// **'Voir toutes les actualités'**
  String get seeAllNews;

  /// No description provided for @newsDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Actualité supprimée !'**
  String get newsDeletedSuccess;

  /// No description provided for @addEventTooltip.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un évènement'**
  String get addEventTooltip;

  /// No description provided for @noUpcomingEvents.
  ///
  /// In fr, this message translates to:
  /// **'Aucun événement à venir.'**
  String get noUpcomingEvents;

  /// No description provided for @seeAllEvents.
  ///
  /// In fr, this message translates to:
  /// **'Voir tous les évènements'**
  String get seeAllEvents;

  /// No description provided for @locationNotSpecified.
  ///
  /// In fr, this message translates to:
  /// **'Lieu non précisé'**
  String get locationNotSpecified;

  /// No description provided for @eventDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Événement supprimé !'**
  String get eventDeletedSuccess;

  /// No description provided for @eventTitleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Titre de l\'évènement'**
  String get eventTitleLabel;

  /// No description provided for @eventTypeMeeting.
  ///
  /// In fr, this message translates to:
  /// **'Rencontre'**
  String get eventTypeMeeting;

  /// No description provided for @eventTypeConference.
  ///
  /// In fr, this message translates to:
  /// **'Conférence'**
  String get eventTypeConference;

  /// No description provided for @eventTypeAfterwork.
  ///
  /// In fr, this message translates to:
  /// **'Afterwork'**
  String get eventTypeAfterwork;

  /// No description provided for @eventTypeWebinar.
  ///
  /// In fr, this message translates to:
  /// **'Webinaire'**
  String get eventTypeWebinar;

  /// No description provided for @dateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Date : '**
  String get dateLabel;

  /// No description provided for @sendProposalBtn.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la proposition'**
  String get sendProposalBtn;

  /// No description provided for @proposalSentSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Proposition envoyée à l\'administrateur !'**
  String get proposalSentSuccess;

  /// No description provided for @drawerMap.
  ///
  /// In fr, this message translates to:
  /// **'Cartes'**
  String get drawerMap;

  /// No description provided for @sectionErrors.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionErrors;

  /// No description provided for @errorOccurred.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorOccurred;

  /// No description provided for @errorSomethingWentWrong.
  ///
  /// In fr, this message translates to:
  /// **'Quelque chose s\'est mal passé. Veuillez réessayer plus tard.'**
  String get errorSomethingWentWrong;

  /// No description provided for @errorAccessDenied.
  ///
  /// In fr, this message translates to:
  /// **'Accès refusé (403)'**
  String get errorAccessDenied;

  /// No description provided for @errorNoPermission.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas les permissions requises pour voir cette page.'**
  String get errorNoPermission;

  /// No description provided for @errorPageNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Page introuvable (404)'**
  String get errorPageNotFound;

  /// No description provided for @errorDataNotFound.
  ///
  /// In fr, this message translates to:
  /// **'La page ou les données que vous cherchez n\'existent pas.'**
  String get errorDataNotFound;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Erreur réseau'**
  String get errorNetwork;

  /// No description provided for @errorNoConnection.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de se connecter au serveur. Vérifiez votre connexion.'**
  String get errorNoConnection;

  /// No description provided for @errorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get errorTitle;

  /// No description provided for @sectionKeyFigures.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionKeyFigures;

  /// No description provided for @updateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mise à jour réussie !'**
  String get updateSuccess;

  /// No description provided for @numberLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nombre'**
  String get numberLabel;

  /// No description provided for @suffixLabel.
  ///
  /// In fr, this message translates to:
  /// **'Suffixe (ex: %, +)'**
  String get suffixLabel;

  /// No description provided for @titleLabelAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Titre du bloc'**
  String get titleLabelAdmin;

  /// No description provided for @iconLabel.
  ///
  /// In fr, this message translates to:
  /// **'Icône'**
  String get iconLabel;

  /// No description provided for @blockLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bloc'**
  String get blockLabel;

  /// No description provided for @livePreview.
  ///
  /// In fr, this message translates to:
  /// **'Aperçu en direct'**
  String get livePreview;

  /// No description provided for @profileBadgeWidget.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get profileBadgeWidget;

  /// No description provided for @loginBtn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginBtn;

  /// No description provided for @accountOf.
  ///
  /// In fr, this message translates to:
  /// **'Compte de'**
  String get accountOf;

  /// No description provided for @editProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get editProfile;

  /// No description provided for @viewAccount.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le compte'**
  String get viewAccount;

  /// No description provided for @filtreWidget.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get filtreWidget;

  /// No description provided for @filterPromotions.
  ///
  /// In fr, this message translates to:
  /// **'Promotions :'**
  String get filterPromotions;

  /// No description provided for @filterSectors.
  ///
  /// In fr, this message translates to:
  /// **'Filières :'**
  String get filterSectors;

  /// No description provided for @filterInternshipCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays Stage :'**
  String get filterInternshipCountry;

  /// No description provided for @sectionEvents.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionEvents;

  /// No description provided for @searchEvent.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un évènement...'**
  String get searchEvent;

  /// No description provided for @editEvent.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'évènement'**
  String get editEvent;

  /// No description provided for @addEvent.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un évènement'**
  String get addEvent;

  /// No description provided for @details.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get details;

  /// No description provided for @sectionArticle.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionArticle;

  /// No description provided for @deleteArticleTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer l\'article ?'**
  String get deleteArticleTitle;

  /// No description provided for @deleteArticleContent.
  ///
  /// In fr, this message translates to:
  /// **'Voulez-vous vraiment supprimer définitivement :\n\n'**
  String get deleteArticleContent;

  /// No description provided for @articleDeletedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Article supprimé.'**
  String get articleDeletedSuccess;

  /// No description provided for @newArticle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvel Article'**
  String get newArticle;

  /// No description provided for @articleContentLabel.
  ///
  /// In fr, this message translates to:
  /// **'Contenu de l\'article'**
  String get articleContentLabel;

  /// No description provided for @searchArticle.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un article...'**
  String get searchArticle;

  /// No description provided for @noArticle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun article.'**
  String get noArticle;

  /// No description provided for @byAuthor.
  ///
  /// In fr, this message translates to:
  /// **'Par '**
  String get byAuthor;

  /// No description provided for @publishedOn.
  ///
  /// In fr, this message translates to:
  /// **'• Publié le '**
  String get publishedOn;

  /// No description provided for @creditDR.
  ///
  /// In fr, this message translates to:
  /// **'Crédit: DR'**
  String get creditDR;

  /// No description provided for @defaultTagNews.
  ///
  /// In fr, this message translates to:
  /// **'ACTUALITÉ'**
  String get defaultTagNews;

  /// No description provided for @unknownCity.
  ///
  /// In fr, this message translates to:
  /// **'Inconnue'**
  String get unknownCity;

  /// No description provided for @editOffer.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'offre'**
  String get editOffer;

  /// No description provided for @offerEditedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Offre modifiée !'**
  String get offerEditedSuccess;

  /// No description provided for @offerPublishedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Offre publiée !'**
  String get offerPublishedSuccess;

  /// No description provided for @serverError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur serveur'**
  String get serverError;

  /// No description provided for @editBtn.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editBtn;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @microsoftError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur Microsoft : '**
  String get microsoftError;

  /// No description provided for @addAlumniFormTitle.
  ///
  /// In fr, this message translates to:
  /// **'Formulaire d\'ajout d\'alumni'**
  String get addAlumniFormTitle;

  /// No description provided for @detailLabelEndDate.
  ///
  /// In fr, this message translates to:
  /// **'Date de fin'**
  String get detailLabelEndDate;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Profil mis à jour avec succès !'**
  String get profileUpdatedSuccess;

  /// No description provided for @saveBtn.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveBtn;

  /// No description provided for @dateTo.
  ///
  /// In fr, this message translates to:
  /// **' au '**
  String get dateTo;

  /// No description provided for @sectionAdmin.
  ///
  /// In fr, this message translates to:
  /// **''**
  String get sectionAdmin;

  /// No description provided for @adminNoPendingRequests.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande en attente.'**
  String get adminNoPendingRequests;

  /// No description provided for @adminReceivedOn.
  ///
  /// In fr, this message translates to:
  /// **'Reçu le : '**
  String get adminReceivedOn;

  /// No description provided for @adminVerifyValidateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérification & Validation'**
  String get adminVerifyValidateTitle;

  /// No description provided for @adminRequestProcessedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Demande traitée avec succès !'**
  String get adminRequestProcessedSuccess;

  /// No description provided for @adminCorruptedDataError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de données corrompues'**
  String get adminCorruptedDataError;

  /// No description provided for @adminValidationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Validation'**
  String get adminValidationTitle;

  /// No description provided for @adminPostedBy.
  ///
  /// In fr, this message translates to:
  /// **'Posté par'**
  String get adminPostedBy;

  /// No description provided for @notProvided.
  ///
  /// In fr, this message translates to:
  /// **'Non renseigné'**
  String get notProvided;

  /// No description provided for @adminRequestRejected.
  ///
  /// In fr, this message translates to:
  /// **'Demande refusée/supprimée'**
  String get adminRequestRejected;

  /// No description provided for @rejectBtn.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get rejectBtn;

  /// No description provided for @adminRequestApproved.
  ///
  /// In fr, this message translates to:
  /// **'Demande validée avec succès !'**
  String get adminRequestApproved;

  /// No description provided for @validateAndPublishBtn.
  ///
  /// In fr, this message translates to:
  /// **'Valider et Publier'**
  String get validateAndPublishBtn;

  /// No description provided for @event.
  ///
  /// In fr, this message translates to:
  /// **'Évènement'**
  String get event;

  /// No description provided for @offer.
  ///
  /// In fr, this message translates to:
  /// **'Offre'**
  String get offer;

  /// No description provided for @noEmail.
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'email'**
  String get noEmail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
