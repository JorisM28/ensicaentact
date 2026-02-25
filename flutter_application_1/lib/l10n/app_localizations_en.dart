// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sectionCommun => '';

  @override
  String get cancel => 'Cancel';

  @override
  String get close => 'Close';

  @override
  String get deleteBtn => 'Delete';

  @override
  String get publish => 'Publish';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get required => 'Required';

  @override
  String get validate => 'Validate';

  @override
  String get backBtn => 'Back';

  @override
  String get reloadBtn => 'Reload';

  @override
  String get untitled => 'Untitled';

  @override
  String get sectionNavigation => '';

  @override
  String get homeTab => 'Home';

  @override
  String get eventsTab => 'Events';

  @override
  String get drawerMenu => 'Menu';

  @override
  String get drawerNews => 'News';

  @override
  String get drawerDirectory => 'Directory';

  @override
  String get drawerOffers => 'Offers';

  @override
  String get drawerSchoolSite => 'School Website';

  @override
  String get drawerProposeEvent => 'Propose an Event';

  @override
  String get drawerJoin => 'Join';

  @override
  String get drawerModeration => 'Moderation';

  @override
  String get sectionRecherchesStages => '';

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
  String get deleteOfferTitle => 'Delete offer?';

  @override
  String get deleteOfferContent => 'This action cannot be undone.';

  @override
  String get offerDeletedSuccess => 'Offer deleted';

  @override
  String get offerDeletedError => 'Error deleting offer';

  @override
  String get seeAllOffers => 'See all offers';

  @override
  String get sectionAnnuaireEntreprises => '';

  @override
  String get companiesDirectory => 'Companies Directory';

  @override
  String get unknownCompany => 'Unknown';

  @override
  String get alumniLabel => 'alumni';

  @override
  String get companiesFilterCompany => 'By Company';

  @override
  String get companiesFilterCity => 'By City';

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

  @override
  String get sectionWidgetsAndDialogs => '';

  @override
  String get dialogLoginRequiredNews => 'Please log in to publish news.';

  @override
  String get dialogNewNews => 'New News';

  @override
  String get dialogTitleLabel => 'Title';

  @override
  String get dialogImageUrlLabel => 'Image URL (optional)';

  @override
  String get dialogNewEvent => 'New Event';

  @override
  String get dialogLocationLabel => 'Location';

  @override
  String get dialogDateTimeLabel => 'Date and Time';

  @override
  String get addNewsTooltip => 'Add news';

  @override
  String get noNewsAvailable => 'No news available.';

  @override
  String get seeAllNews => 'See all news';

  @override
  String get newsDeletedSuccess => 'News deleted!';

  @override
  String get addEventTooltip => 'Add event';

  @override
  String get noUpcomingEvents => 'No upcoming events.';

  @override
  String get seeAllEvents => 'See all events';

  @override
  String get locationNotSpecified => 'Location not specified';

  @override
  String get eventDeletedSuccess => 'Event deleted!';

  @override
  String get eventTitleLabel => 'Event Title';

  @override
  String get eventTypeMeeting => 'Meeting';

  @override
  String get eventTypeConference => 'Conference';

  @override
  String get eventTypeAfterwork => 'Afterwork';

  @override
  String get eventTypeWebinar => 'Webinar';

  @override
  String get dateLabel => 'Date: ';

  @override
  String get sendProposalBtn => 'Send Proposal';

  @override
  String get proposalSentSuccess => 'Proposal sent to the administrator!';

  @override
  String get sectionErrors => '';

  @override
  String get errorOccurred => 'An Error Occurred';

  @override
  String get errorSomethingWentWrong =>
      'Something went wrong. Please try again later.';

  @override
  String get errorAccessDenied => 'Access Denied (403)';

  @override
  String get errorNoPermission =>
      'You do not have the required permissions to view this page.';

  @override
  String get errorPageNotFound => 'Page Not Found (404)';

  @override
  String get errorDataNotFound =>
      'The page or data you are looking for does not exist.';

  @override
  String get errorNetwork => 'Network Error';

  @override
  String get errorNoConnection =>
      'Unable to connect to the server. Please check your connection.';

  @override
  String get errorTitle => 'Error';

  @override
  String get sectionKeyFigures => '';

  @override
  String get updateSuccess => 'Update successful!';

  @override
  String get numberLabel => 'Number';

  @override
  String get suffixLabel => 'Suffix';

  @override
  String get titleLabelAdmin => 'Title (Label)';

  @override
  String get iconLabel => 'Icon';

  @override
  String get blockLabel => 'Block';

  @override
  String get livePreview => 'Live Preview';
}
