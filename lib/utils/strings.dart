

const welcome = "Welcome Back";




bool isEmpty(String? s )=> s==null || s== "null" || s.trim().isEmpty;
bool isNotEmpty(String? s )=> s !=null && s != "null" && s.trim().isNotEmpty;

String formatError(String s )=> s.replaceAll("Exception:", "");