import 'package:flutter_lunar_datetime_picker/datetime_util.dart';
import 'package:lunar/lunar.dart';

//interface for picker data model
abstract class BasePickerModel {
  //a getter method for left column data, return null to end list
  String? leftStringAtIndex(int index);

  //a getter method for middle column data, return null to end list
  String? middleStringAtIndex(int index);

  //a getter method for right column data, return null to end list
  String? rightStringAtIndex(int index);

  //set selected left index
  void setLeftIndex(int index);

  //set selected middle index
  void setMiddleIndex(int index);

  //set selected right index
  void setRightIndex(int index);

  //return current left index
  int currentLeftIndex();

  //return current middle index
  int currentMiddleIndex();

  //return current right index
  int currentRightIndex();

  //return final time
  DateTime? finalTime();

  //return left divider string
  String leftDivider();

  //return right divider string
  String rightDivider();

  //layout proportions for 3 columns
  List<int> layoutProportions();
}
//a base class for picker data model
class CommonPickerModel extends BasePickerModel {
  late List<String> leftList;
  late List<String> middleList;
  late List<String> rightList;
  late DateTime currentTime;
  late int _currentLeftIndex;
  late int _currentMiddleIndex;
  late int _currentRightIndex;

  CommonPickerModel();

  @override
  String? leftStringAtIndex(int index) {
    return null;
  }

  @override
  String? middleStringAtIndex(int index) {
    return null;
  }

  @override
  String? rightStringAtIndex(int index) {
    return null;
  }

  @override
  int currentLeftIndex() {
    return _currentLeftIndex;
  }

  @override
  int currentMiddleIndex() {
    return _currentMiddleIndex;
  }

  @override
  int currentRightIndex() {
    return _currentRightIndex;
  }

  @override
  void setLeftIndex(int index) {
    _currentLeftIndex = index;
  }

  @override
  void setMiddleIndex(int index) {
    _currentMiddleIndex = index;
  }

  @override
  void setRightIndex(int index) {
    _currentRightIndex = index;
  }

  @override
  String leftDivider() {
    return "";
  }

  @override
  String rightDivider() {
    return "";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }

  @override
  DateTime? finalTime() {
    return null;
  }
}
//a date picker model
class DatePickerModel extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;

  DatePickerModel({
    DateTime? currentTime,
    DateTime? maxTime,
    DateTime? minTime,
  }) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);

    currentTime = currentTime ?? DateTime.now();

    if (currentTime.compareTo(this.maxTime) > 0) {
      currentTime = this.maxTime;
    } else if (currentTime.compareTo(this.minTime) < 0) {
      currentTime = this.minTime;
    }

    this.currentTime = currentTime;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = this.currentTime.year - this.minTime.year;
    _currentMiddleIndex = this.currentTime.month - minMonth;
    _currentRightIndex = this.currentTime.day - minDay;
  }

  void _fillLeftLists() {
    leftList = List.generate(maxTime.year - minTime.year + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minTime.year + index}年';
    });
  }

  int _maxMonthOfCurrentYear() {
    return currentTime.year == maxTime.year ? maxTime.month : 12;
  }

  int _minMonthOfCurrentYear() {
    return currentTime.year == minTime.year ? minTime.month : 1;
  }

  int _maxDayOfCurrentMonth() {
    int dayCount = calcDateCount(currentTime.year, currentTime.month);
    return currentTime.year == maxTime.year &&
            currentTime.month == maxTime.month
        ? maxTime.day
        : dayCount;
  }

  int _minDayOfCurrentMonth() {
    return currentTime.year == minTime.year &&
            currentTime.month == minTime.month
        ? minTime.day
        : 1;
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    middleList = List.generate(maxMonth - minMonth + 1, (int index) {
      return '${minMonth + index}月';
    });
  }

  void _fillRightLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    rightList = List.generate(maxDay - minDay + 1, (int index) {
      return '${minDay + index}日}';
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minTime.year;
    int minMonth = _minMonthOfCurrentYear();
    DateTime newTime;
    //change date time
    if (currentTime.month == 2 && currentTime.day == 29) {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            )
          : DateTime(
              destYear,
              currentTime.month,
              calcDateCount(destYear, 2),
            );
    } else {
      newTime = currentTime.isUtc
          ? DateTime.utc(
              destYear,
              currentTime.month,
              currentTime.day,
            )
          : DateTime(
              destYear,
              currentTime.month,
              currentTime.day,
            );
    }
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillMiddleLists();
    _fillRightLists();
    minMonth = _minMonthOfCurrentYear();
    int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = currentTime.month - minMonth;
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = _minMonthOfCurrentYear();
    int destMonth = minMonth + index;
    DateTime newTime;
    //change date time
    int dayCount = calcDateCount(currentTime.year, destMonth);
    newTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          )
        : DateTime(
            currentTime.year,
            destMonth,
            currentTime.day <= dayCount ? currentTime.day : dayCount,
          );
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
    } else {
      currentTime = newTime;
    }

    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentRightIndex = currentTime.day - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = _minDayOfCurrentMonth();
    currentTime = currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            minDay + index,
          )
        : DateTime(
            currentTime.year,
            currentTime.month,
            minDay + index,
          );
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    return currentTime;
  }
}

class LunarPickerModel extends CommonPickerModel {
  late DateTime maxTime;
  late DateTime minTime;
  late Lunar maxLunarTime;
  late Lunar minLunarTime;
  late Lunar currentLunarTime;
  LunarPickerModel(
      {DateTime? currentTime, DateTime? maxTime, DateTime? minTime}) {
    this.maxTime = maxTime ?? DateTime(2049, 12, 31);
    this.minTime = minTime ?? DateTime(1970, 1, 1);
    currentTime = currentTime ?? DateTime.now();
    // 阳历转阴历
    maxLunarTime = Solar.fromDate(this.maxTime).getLunar();
    minLunarTime = Solar.fromDate(this.minTime).getLunar();
    // 获取当前阴历
    currentLunarTime = Solar.fromDate(currentTime).getLunar();

    if (currentTime.compareTo(this.maxTime) > 0) {
      currentTime = this.maxTime;
      currentLunarTime = maxLunarTime;
    } else if (currentTime.compareTo(this.minTime) < 0) {
      currentTime = this.minTime;
      currentLunarTime = minLunarTime;
    }

    this.currentTime = currentTime;

    _fillLeftLists();
    _fillMiddleLists();
    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentLeftIndex = currentLunarTime.getYear() - minLunarTime.getYear();
    _currentMiddleIndex = _getCurrentMiddleIndex();
    _currentRightIndex = currentLunarTime.getDay() - minDay;
  }

  /// 当前年的最大月份
  int _maxMonthOfCurrentYear() {
    return currentLunarTime.getYear() == maxLunarTime.getYear()
        ? maxLunarTime.getMonth()
        : 12;
  }

  /// 当前年的最小月份
  int _minMonthOfCurrentYear() {
    return currentLunarTime.getYear() == minLunarTime.getYear()
        ? minLunarTime.getMonth()
        : 1;
  }

  /// 当月的最大天数
  int _maxDayOfCurrentMonth() {
    // 当月天数
    int dayCount = LunarMonth.fromYm(
                currentLunarTime.getYear(), currentLunarTime.getMonth())
            ?.getDayCount() ??
        0;
    return currentLunarTime.getYear() == maxLunarTime.getYear() &&
            currentLunarTime.getMonth() == maxLunarTime.getMonth()
        ? maxLunarTime.getDay()
        : dayCount;
  }

  /// 当月的最小天数
  int _minDayOfCurrentMonth() {
    return currentLunarTime.getYear() == minLunarTime.getYear() &&
            currentLunarTime.getMonth() == minLunarTime.getMonth()
        ? minLunarTime.getDay()
        : 1;
  }

  void _fillLeftLists() {
    leftList = List.generate(
        maxLunarTime.getYear() - minLunarTime.getYear() + 1, (int index) {
      // print('LEFT LIST... ${minTime.year + index}${_localeYear()}');
      return '${minLunarTime.getYear() + index}年';
    });
  }

  String getYearInChinese(int year) {
    String y = year.toString();
    String s = '';
    for (int i = 0, j = y.length; i < j; i++) {
      s += LunarUtil.NUMBER[y.codeUnitAt(i) - 48];
    }
    return s;
  }

  void _fillMiddleLists() {
    int minMonth = _minMonthOfCurrentYear();
    int maxMonth = _maxMonthOfCurrentYear();

    var lunarMonths =
        LunarYear.fromYear(currentLunarTime.getYear()).getMonths();

    middleList = [];

    // print("--${lunarMonths.length}");
    // 因为农历月份中有闰月所以需要遍历当前所有月份进行查找
    for (var i = 0, j = lunarMonths.length; i < j; i++) {
      print(lunarMonths[i].toString());
      if (lunarMonths[i].getYear() == currentLunarTime.getYear()) {
        if (currentLunarTime.getYear() == minLunarTime.getYear()) {
          if (i >= minMonth + 1) {
            getLunarMiddleMonth(lunarMonths[i]);
          }
        } else if (currentLunarTime.getYear() == maxLunarTime.getYear()) {
          if (i <= maxMonth + 1) {
            getLunarMiddleMonth(lunarMonths[i]);
          }
        } else {
          getLunarMiddleMonth(lunarMonths[i]);
        }
      }
    }
    // print(this.middleList.length);
  }

  /// 检查是否是闰月
  bool isLeap(LunarMonth m) => m.getMonth() < 0;

  /// 格式化获取农历月
  getLunarMiddleMonth(LunarMonth m) {
    String month = LunarUtil.MONTH[m.getMonth().abs()];
    middleList.add("${isLeap(m) ? "闰" : ""}$month月");
  }

  void _fillRightLists() {
    int maxDay = _maxDayOfCurrentMonth();
    int minDay = _minDayOfCurrentMonth();
    // print("${currentLunarTime.toString()}-${_maxDayOfCurrentMonth()}");
    rightList = List.generate(
        maxDay - minDay + 1 < _maxDayOfCurrentMonth()
            ? maxDay - minDay + 1
            : _maxDayOfCurrentMonth(), (int index) {
      return LunarUtil.DAY[minDay + index];
    });
  }

  @override
  void setLeftIndex(int index) {
    super.setLeftIndex(index);
    //adjust middle
    int destYear = index + minLunarTime.getYear();
    DateTime newTime;

    // 当月天数
    int dayCount =
        LunarMonth.fromYm(destYear, currentTime.month)?.getDayCount() ?? 0;
    // 当前日期不能大于当月最大天数 & d当前月可能无闰月
    Lunar newLunarTime = Lunar.fromYmd(
        destYear,
        currentLunarTime.getMonth().abs(),
        currentLunarTime.getDay() < dayCount
            ? currentLunarTime.getDay()
            : dayCount);

    // 阴历转阳历
    var solarTime = newLunarTime.getSolar();
    newTime =
        DateTime(solarTime.getYear(), solarTime.getMonth(), solarTime.getDay());

    // 此处使用阳历进行时间对比，阴历没有
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
      currentLunarTime = maxLunarTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
      currentLunarTime = minLunarTime;
    } else {
      currentTime = newTime;
      currentLunarTime = newLunarTime;
    }
    // print(currentTime);

    _fillMiddleLists();
    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentMiddleIndex = _getCurrentMiddleIndex();
    _currentRightIndex = currentLunarTime.getDay() - minDay;
  }

  //获取当前最小月份指针
  int _getCurrentMiddleIndex() {
    int mCurrentMiddleIndex = 0;
    bool isLeap = LunarMonth.fromYm(
                currentLunarTime.getYear(), currentLunarTime.getMonth())
            ?.isLeap() ??
        false;
    if (isLeap) {
      // 当前最小月为闰月
      if (_minMonthOfCurrentYear() < 0) {
        mCurrentMiddleIndex = 0;
      } else {
        // 闰月会出现相同的月份所以指针+1
        mCurrentMiddleIndex =
            currentLunarTime.getMonth().abs() - _minMonthOfCurrentYear() + 1;
      }
    } else {
      mCurrentMiddleIndex =
          currentLunarTime.getMonth().abs() - _minMonthOfCurrentYear();
    }
    return mCurrentMiddleIndex;
  }

  @override
  void setMiddleIndex(int index) {
    super.setMiddleIndex(index);
    //adjust right
    int minMonth = _minMonthOfCurrentYear();

    var d = LunarMonth.fromYm(currentLunarTime.getYear(), minMonth);
    // 往后推x个月
    LunarMonth? nextMonth = d?.next(index);

    int dayCount = LunarMonth.fromYm(
                currentLunarTime.getYear(), nextMonth?.getMonth() ?? 0)
            ?.getDayCount() ??
        0;

    Lunar newLunarTime = Lunar.fromYmd(
        currentLunarTime.getYear(),
        nextMonth?.getMonth() ?? 0,
        currentLunarTime.getDay() <= dayCount
            ? currentLunarTime.getDay()
            : dayCount);

    DateTime newTime;
    // 阴历转阳历
    var solarTime = newLunarTime.getSolar();
    newTime =
        DateTime(solarTime.getYear(), solarTime.getMonth(), solarTime.getDay());
    //min/max check
    if (newTime.isAfter(maxTime)) {
      currentTime = maxTime;
      currentLunarTime = maxLunarTime;
    } else if (newTime.isBefore(minTime)) {
      currentTime = minTime;
      currentLunarTime = minLunarTime;
    } else {
      currentTime = newTime;
      currentLunarTime = newLunarTime;
    }

    _fillRightLists();
    int minDay = _minDayOfCurrentMonth();
    _currentRightIndex = currentLunarTime.getDay() - minDay;
  }

  @override
  void setRightIndex(int index) {
    super.setRightIndex(index);
    int minDay = _minDayOfCurrentMonth();
    int maxDay = _maxDayOfCurrentMonth();

    ///此处需要注意不能超过本月最大天数
    Lunar newLunarTime = Lunar.fromYmd(
        currentLunarTime.getYear(),
        currentLunarTime.getMonth(),
        (minDay + index <= maxDay) ? minDay + index : maxDay);
    currentLunarTime = newLunarTime;
    // 阴历转阳历
    var solarTime = newLunarTime.getSolar();
    currentTime =
        DateTime(solarTime.getYear(), solarTime.getMonth(), solarTime.getDay());
  }

  @override
  String? leftStringAtIndex(int index) {
    if (index >= 0 && index < leftList.length) {
      return leftList[index];
    } else {
      return null;
    }
  }

  @override
  String? middleStringAtIndex(int index) {
    if (index >= 0 && index < middleList.length) {
      return middleList[index];
    } else {
      return null;
    }
  }

  @override
  String? rightStringAtIndex(int index) {
    if (index >= 0 && index < rightList.length) {
      return rightList[index];
    } else {
      return null;
    }
  }

  @override
  DateTime finalTime() {
    return currentTime;
  }
}
