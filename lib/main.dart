import 'package:flutter/material.dart';

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
  final List<Event> _events = <Event>[];
  static int _selectedIndex = 0;
  Color themeColor = Colors.teal;
/*   static Event curr = Event(date: DateTime.now());
 */
  static DateTime curr = DateTime.now();
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
      return now.difference(_events[index].date).inDays.toString();
    } else if (type == 1) {
      return (now.difference(_events[index].date).inDays ~/ 7).toString();
    } else if (type == 2) {
      return (now.difference(_events[index].date).inDays ~/ 30).toString();
    }
    return '';
  }

  String _getName(int index) {
    if (_events[index].name.isNotEmpty) {
      return _events[index].name;
    } else {
      return '';
    }
  }

  String _getDate(int index) {
    if (index < _events.length) {
      return _events[index].date.day.toString() +
          '/' +
          _events[index].date.month.toString() +
          '/' +
          _events[index].date.year.toString();
    }
    return '';
  }

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
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    color: themeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_getName(index) + ' '),
                          Row(
                            children: [
                              Text(
                                _differnce(index, 0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              const Text(' days')
                            ],
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_getDate(index)),
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
                                          _events.removeAt(index);
                                        });
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        )
                      ],
                    ));
              },
              itemCount: _events.length,
            ),
          ),
          Center(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    color: themeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_getName(index) + ' '),
                          Row(
                            children: [
                              Text(
                                _differnce(index, 1),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              const Text(' weeks')
                            ],
                          ),
                        ],
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_getDate(index)),
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
                                        _events.removeAt(index);
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ],
                    ));
              },
              itemCount: _events.length,
            ),
          ),
          Center(
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                    margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                    color: themeColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: ExpansionTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_getName(index) + ' '),
                          Row(
                            children: [
                              Text(
                                _differnce(index, 2),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              const Text(' months')
                            ],
                          ),
                        ],
                      ),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_getDate(index)),
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
                                        _events.removeAt(index);
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ],
                    ));
              },
              itemCount: _events.length,
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
          eventController.text = '';
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
                _events.add(Event(date: curr, name: eventController.text));
              });
            } else {
              eventController.clear();
            }
          });
          curr = DateTime.now();
        },
        backgroundColor: themeColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Event {
  DateTime date;
  String name;
  bool isExpanded;
  Event({required this.date, required this.name, this.isExpanded = false});
}

List<Event> generateEvents(int numberOfEvents, DateTime date, String name) {
  return List<Event>.generate(numberOfEvents, (int index) {
    return Event(
      date: date,
      name: name,
    );
  });
}
