
/// Outputs year as four digits
///
/// Example:
///     formatDate(new DateTime(2018,8,31), [ymdw]);
///     // => Today
const String ymdw = 'ymdw';

///
/// Example:
///     formatDate(new DateTime(1989), [yyyy]);
///     // => 1989
const String yyyy = 'yyyy';

/// Outputs year as two digits
///
/// Example:
///     formatDate(new DateTime(1989), [yy]);
///     // => 89
const String yy = 'yy';

/// Outputs month as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(new DateTime(1989, 5), [mm]);
///     // => 05
const String mm = 'mm';

/// Outputs month compactly
///
/// Example:
///     formatDate(new DateTime(1989, 11), [mm]);
///     // => 11
///     formatDate(new DateTime(1989, 5), [m]);
///     // => 5
const String m = 'm';

/// Outputs month as long name
///
/// Example:
///     formatDate(new DateTime(1989, 2), [MM]);
///     // => february
const String MM = 'MM';

/// Outputs month as short name
///
/// Example:
///     formatDate(new DateTime(1989, 2), [M]);
///     // => feb
const String M = 'M';

/// Outputs day as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [dd]);
///     // => 21
///     formatDate(new DateTime(1989, 2, 5), [dd]);
///     // => 05
const String dd = 'dd';

/// Outputs day compactly
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [d]);
///     // => 21
///     formatDate(new DateTime(1989, 2, 5), [d]);
///     // => 5
const String d = 'd';

/// Outputs week in month
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [w]);
///     // => 4
const String w = 'w';

/// Outputs week in year as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 12, 31), [W]);
///     // => 53
///     formatDate(new DateTime(1989, 2, 21), [W]);
///     // => 08
const String WW = 'WW';

/// Outputs week in year compactly
///
/// Example:
///     formatDate(new DateTime(1989, 2, 21), [W]);
///     // => 8
const String W = 'W';

/// Outputs week day as long name
///
/// Example:
///     formatDate(new DateTime(2018, 1, 14), [D]);
///     // => sun
const String D = 'D';

/// Outputs hour (0 - 11) as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15), [hh]);
///     // => 03
const String hh = 'hh';

/// Outputs hour (0 - 11) compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15), [h]);
///     // => 3
const String h = 'h';

/// Outputs hour (0 to 23) as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15), [HH]);
///     // => 15
const String HH = 'HH';

/// Outputs hour (0 to 23) compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 5), [H]);
///     // => 5
const String H = 'H';

/// Outputs minute as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40), [nn]);
///     // => 40
///     formatDate(new DateTime(1989, 02, 1, 15, 4), [nn]);
///     // => 04
const String nn = 'nn';

/// Outputs minute compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 4), [n]);
///     // => 4
const String n = 'n';

/// Outputs second as two digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10), [ss]);
///     // => 10
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 5), [ss]);
///     // => 05
const String ss = 'ss';

/// Outputs second compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 5), [s]);
///     // => 5
const String s = 's';

/// Outputs millisecond as three digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 099
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0), [SS]);
///     // => 009
const String SSS = 'SSS';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 999), [SSS]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 99), [SS]);
///     // => 99
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 9), [SS]);
///     // => 9
const String S = 'S';

/// Outputs microsecond as three digits
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [uuu]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [uuu]);
///     // => 099
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [uuu]);
///     // => 009
const String uuu = 'uuu';

/// Outputs millisecond compactly
///
/// Example:
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 999), [u]);
///     // => 999
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 99), [u]);
///     // => 99
///     formatDate(new DateTime(1989, 02, 1, 15, 40, 10, 0, 9), [u]);
///     // => 9
const String u = 'u';

/// Outputs if hour is AM or PM
///
/// Example:
///     print(formatDate(new DateTime(1989, 02, 1, 5), [am]));
///     // => AM
///     print(formatDate(new DateTime(1989, 02, 1, 15), [am]));
///     // => PM
const String am = 'am';

/// Outputs timezone as time offset
///
/// Example:
///
const String z = 'z';
const String Z = 'Z';


String digits(int value, int length) {
  return '$value'.padLeft(length, "0");
}

int dayInYear(DateTime date) =>
    date.difference(DateTime(date.year, 1, 1)).inDays;
