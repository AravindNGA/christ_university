import 'package:christ_university/utils/shared_prefs.dart';

import 'important_variables.dart';

class ClearAllSharedPrefsDuringSignOut{


  ClearAllSharedPrefsDuringSignOut(){

    preferencesShared.setSaveAString(ImportantVariables.userFirstNameSharPref, "");

    preferencesShared.setSaveBooleanState(ImportantVariables.didStudentLoginSharPref, false);
    preferencesShared.setSaveBooleanState(ImportantVariables.loggedInStateSharPref, false);

  }
}