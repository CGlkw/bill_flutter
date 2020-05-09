class DateUtils {
  
  static final List weekList = ['','周一','周二','周三','周四','周五','周六','周日'];

  static String getWeekName(DateTime date){
    return weekList[date.weekday];
  }



}