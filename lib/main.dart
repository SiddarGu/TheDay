import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Day',
      theme: ThemeData(brightness: Brightness.dark),
      home: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class DateText extends StatefulWidget {
  const DateText({Key? key}) : super(key: key);

  @override
  State<DateText> createState() => _DateTextState();
}

class _DateTextState extends State<DateText> {
  String time = '';
  DateTime selectedDate = DateTime.now();

  String date =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(1965),
                      lastDate: DateTime.now())
                  .then((value) => setState(() {
                        if (value != null && value != selectedDate) {
                          selectedDate = value;
                          date =
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                          _MyStatefulWidgetState.curr = selectedDate;
                        }
                      }));
            },
            icon: const Icon(Icons.calendar_month_outlined)),
        Text(date)
      ],
    );
  }
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<int> bottom = <int>[0];
  List<Event> events = <Event>[];
  static int _selectedIndex = 0;
  Color themeColor = Colors.teal;
/*   static Event curr = Event(date: DateTime.now());
 */  static DateTime curr = DateTime.now();
  TextEditingController eventController = TextEditingController();
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String date =
      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

  String _differnce(int index, int type) {
    // type 0 = days
    // type 1 = weeks
    // type 2 = months
    DateTime now = DateTime.now();
    if (type == 0) {
      return now.difference(events[index].date).inDays.toString();
    } else if (type == 1) {
      return (now.difference(events[index].date).inDays ~/ 7).toString();
    } else if (type == 2) {
      return (now.difference(events[index].date).inDays ~/ 30).toString();
    }
    return '';
  }

  String _getDate(int index) {
    if (index < events.length) {
      return events[index].date.day.toString() +
          '/' +
          events[index].date.month.toString() +
          '/' +
          events[index].date.year.toString();
    }
    return '';
  }

/*   void _onSwipe(int index) {
    setState(() {
      _selectedIndex = index;
      themeColor = index == 0
          ? Colors.teal
          : (index == 1 ? Colors.cyan : Colors.lightBlue);
    });
  } */

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
      themeColor = index == 0
          ? Colors.teal
          : (index == 1 ? Colors.cyan : Colors.lightBlue);
    });
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey<String>('bottom-sliver-list');

    return Scaffold(
      appBar: AppBar(
        title: const Text('The Day'),
        backgroundColor: themeColor,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int index) {
          _onItemTapped(index);
        },
        children: [
          Center(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  key: centerKey,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Card(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(_getDate(index)),
                              Text(_differnce(index, 0)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text('Delete?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context,
                                                    false), // passing false
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context,
                                                    true), // passing true
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        }).then((exit) {
                                      if (exit) {
                                        setState(() {
                                          bottom.removeAt(index);
                                          events.removeAt(index);
                                        });
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),

                          alignment: Alignment.center,
                          //color: Colors.blue[200 + bottom[index] % 4 * 100],
                          height: 100,
                          //child: ,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeColor,
                          ),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  key: centerKey,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Card(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(_getDate(index)),
                              Text(_differnce(index, 1)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text('Delete?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context,
                                                    false), // passing false
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context,
                                                    true), // passing true
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        }).then((exit) {
                                      if (exit) {
                                        setState(() {
                                          bottom.removeAt(index);
                                          events.removeAt(index);
                                        });
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),

                          alignment: Alignment.center,
                          //color: Colors.blue[200 + bottom[index] % 4 * 100],
                          height: 100,
                          //child: ,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeColor,
                          ),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  key: centerKey,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Card(
                        margin:
                            const EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(_getDate(index)),
                              Text(_differnce(index, 2)),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text('Delete?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context,
                                                    false), // passing false
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context,
                                                    true), // passing true
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        }).then((exit) {
                                      if (exit) {
                                        setState(() {
                                          bottom.removeAt(index);
                                          events.removeAt(index);
                                        });
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),

                          alignment: Alignment.center,
                          //color: Colors.blue[200 + bottom[index] % 4 * 100],
                          height: 100,
                          //child: ,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: themeColor,
                          ),
                        ),
                      );
                    },
                    childCount: events.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Text('DAYS', style: TextStyle(fontSize: 12)),
            label: 'Home',
            activeIcon: Text('DAYS',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            backgroundColor: Colors.teal,
          ),
          BottomNavigationBarItem(
            icon: Text('WEEKS', style: TextStyle(fontSize: 12)),
            label: 'Business',
            activeIcon: Text('WEEKS',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            backgroundColor: Colors.cyan,
          ),
          BottomNavigationBarItem(
            icon: Text('MONTHS', style: TextStyle(fontSize: 12)),
            label: 'School',
            activeIcon: Text('MONTHS',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15)),
            backgroundColor: Colors.lightBlue,
          ),
        ],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Event name',
                    ),
                    controller: eventController,
                  ),
                  content: const DateText(),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      // passing false
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      // passing true
                      child: const Text('Add'),
                    ),
                  ],
                );
              }).then((exit) {
            if (exit) {
              setState(() {
                bottom.add(bottom.length);
                events.add(Event(date: curr, name: eventController.text));
              });
            } else {
              eventController.clear();
            }
          });
        },
        backgroundColor: themeColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Event {
  DateTime date;
  String name = '';
  Event({required this.date, required this.name});
}
