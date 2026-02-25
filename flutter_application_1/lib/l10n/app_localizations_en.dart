// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sectionRecherchesStages => '';

  @override
  String get deleteOfferTitle => 'Delete offer?';

  @override
  String get deleteOfferContent => 'This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get offerDeletedSuccess => 'Offer deleted';

  @override
  String get offerDeletedError => 'Error deleting offer';

  @override
  String get deleteBtn => 'Delete';

  @override
  String get careersStagesTitle => 'Careers & Internships';

  @override
  String get searchOfferHint => 'Search (Job title, Company...)';

  @override
  String get jobOffersTitle => 'Job Offers';

  @override
  String get internshipOffersTitle => 'Internships';

  @override
  String get noOfferFound => 'No offers found';

  @override
  String get defaultJobTitle => 'Position';

  @override
  String get byPrefix => 'By: ';

  @override
  String get addInternship => 'Add Internship';

  @override
  String get addJob => 'Add Job';

  @override
  String get atLocation => ' in ';

  @override
  String get descriptionLabel => 'Description:';

  @override
  String get descriptionField => 'Description';

  @override
  String get noDescription => 'No description provided';

  @override
  String get contactLabel => 'Contact:';

  @override
  String get close => 'Close';

  @override
  String get newInternship => 'New Internship';

  @override
  String get newJob => 'New Job';

  @override
  String get jobTitleLabel => 'Job Title';

  @override
  String get companyLabel => 'Company';

  @override
  String get cityLabel => 'City';

  @override
  String get typeLabel => 'Type';

  @override
  String get contactEmailLabel => 'Contact Email';

  @override
  String get publish => 'Publish';

  @override
  String get sectionAnnuaireEntreprises => '';

  @override
  String get companiesDirectory => 'Companies Directory';

  @override
  String get unknownCompany => 'Unknown';

  @override
  String get alumniLabel => 'alumni';

  @override
  String get sectionLogin => '';

  @override
  String get loginEmailLabel => 'Email';

  @override
  String get loginEmailRequired => 'Email required';

  @override
  String get loginInvalidEmail => 'Invalid email';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginPasswordRequired => 'Enter a password';

  @override
  String get loginPasswordTooShort => 'Password too short';

  @override
  String get loginForgetPassword => 'Forget Password ?';

  @override
  String get loginSubmitButton => 'LOGIN';

  @override
  String get loginOrDivider => 'OR';

  @override
  String get loginMicrosoftButton => 'Connect with Microsoft 365';

  @override
  String get loginErrorConnection => 'Connection Impossible !';

  @override
  String get loginErrorUnknown => 'Unknown error';

  @override
  String get sectionProfile => '';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileSecurity => 'Security';

  @override
  String get profileModifyPassword => 'Change my password';

  @override
  String get profileLogout => 'Logout';

  @override
  String get modifyPassword => 'Change Password';

  @override
  String get lastPassword => 'Old password';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get required => 'Required';

  @override
  String get minCharacters => 'Minimum 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordChangedSuccess => 'Password changed successfully';

  @override
  String get passwordChangedError => 'Error: Unable to change password';

  @override
  String get unknownUser => 'User';

  @override
  String get validate => 'Validate';

  @override
  String get sectionDirectory => '';

  @override
  String get directoryNoResult => 'No results';

  @override
  String get directorySearchHint => 'Search...';

  @override
  String get directorySelectStudent => 'Select a student';

  @override
  String get directoryNewAlumniTitle => 'New Alumni';

  @override
  String get directoryDeleteConfirmTitle => 'Delete?';

  @override
  String directoryDeleteConfirmContent(Object name) {
    return 'Do you want to delete $name?';
  }

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get directoryHistoryTitle => 'History';

  @override
  String get directoryHistoryEmpty => 'No actions recorded.';

  @override
  String get directoryOnDate => 'on';

  @override
  String get directoryActionDelete => 'DELETION';

  @override
  String get directoryActionAdd => 'ADDITION';

  @override
  String get sectionPreview => '';

  @override
  String get previewInternships => 'Internships:';

  @override
  String get previewSeeFullProfile => 'View full profile';

  @override
  String get sectionDetail => '';

  @override
  String get detailEditTitle => 'Edit Alumni';

  @override
  String detailAge(String years) {
    return '$years years old';
  }

  @override
  String get detailLabelFirstName => 'First Name';

  @override
  String get detailLabelLastName => 'Last Name';

  @override
  String get detailLabelPromo => 'Class (Year)';

  @override
  String get detailLabelBirthDate => 'Date of Birth';

  @override
  String get detailAdminStatus => 'Admin Status';

  @override
  String get detailPermissionData => 'Data Authorization';

  @override
  String get detailVisible => 'Visible';

  @override
  String get detailHidden => 'Hidden';

  @override
  String get detailDeceased => 'Deceased';

  @override
  String get detailDeceasedSubtitle => 'Mark as deceased';

  @override
  String get detailInfoStudies => 'Education';

  @override
  String get detailLabelSector => 'Department';

  @override
  String get detailLabelSpecialisation => 'Major';

  @override
  String get detailLabelOption => 'Option';

  @override
  String get detailLabelDoubleDiploma => 'Double Degree';

  @override
  String get detailInfoPro => 'Professional Info';

  @override
  String get detailLabelJob => 'Position';

  @override
  String get detailLabelJobDesc => 'Job Description';

  @override
  String get detailLabelCity => 'City';

  @override
  String get detailLabelCompany => 'Company';

  @override
  String get detailLabelSeniority => 'Seniority';

  @override
  String get detailLabelStartDate => 'Start Date (Position)';

  @override
  String get detailContactHidden => 'Contact info hidden';

  @override
  String get detailInternshipTitle => 'Internships';

  @override
  String get detailInternshipAdd => 'Add';

  @override
  String get detailInternshipNone => 'No internships listed';

  @override
  String get detailInternshipUniversity => 'University';

  @override
  String get detailInternshipCompany => 'Company';

  @override
  String get detailInternshipLocation => 'Location';

  @override
  String get detailInternshipPeriod => 'Period';

  @override
  String get detailInternshipDescription => 'Description';

  @override
  String get detailLabelCountry => 'Country';

  @override
  String get detailLabelDescription => 'Description';

  @override
  String get sectionForm => '';

  @override
  String get formIdentityTitle => 'Identity';

  @override
  String get formRequired => 'Required';

  @override
  String get formGenderUnknown => 'Unknown';

  @override
  String get formGenderMale => 'Male';

  @override
  String get formGenderFemale => 'Female';

  @override
  String get formConsent => 'Consent to make phone and email visible';

  @override
  String get formFormationTitle => 'ENSI Education';

  @override
  String get formPromoHint => 'Class (e.g. 2024) *';

  @override
  String get formFormationFISE => 'FISE (Student)';

  @override
  String get formFormationFISA => 'FISA (Apprentice)';

  @override
  String get formFormationMTS => 'MTS (Master)';

  @override
  String get formJobTitle => 'Current Position';

  @override
  String get formInternshipsTitle => 'Internships';

  @override
  String get formNoInternship => 'No internship added (optional)';

  @override
  String get formInternshipYear => 'Internship Year';

  @override
  String get formInternship1A => '1st Year (1A)';

  @override
  String get formInternship2A => '2nd Year (2A)';

  @override
  String get formInternship3A => 'Final Year (3A)';

  @override
  String get formInternshipSubject => 'Subject / Title *';

  @override
  String get formInternshipStructureReq => 'Structure type required';

  @override
  String get formInternshipLab => 'Company / Lab Name';

  @override
  String get formAdminRejectTitle => 'Reject request?';

  @override
  String get formAdminRejectContent => 'This action cannot be undone.';

  @override
  String get formAdminRejectConfirm => 'Confirm Rejection';

  @override
  String get formAdminRejectButton => 'REJECT THIS REQUEST';

  @override
  String get formSaveLoading => 'Saving...';

  @override
  String get formSaveButton => 'Save Alumni';

  @override
  String get formMsgAdded => 'Alumni added directly!';

  @override
  String get formMsgPending => 'Request sent for validation.';

  @override
  String formMsgError(String error) {
    return 'Error: $error';
  }
}
