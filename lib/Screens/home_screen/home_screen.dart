import 'package:app/Providers/todo_list_provider.dart';
import 'package:app/screens/add_to_do_screen.dart';
import 'package:app/screens/login_screen/login_screen.dart';
import 'package:app/screens/notes_screen/notes_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/define_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  void navigateToAddTodoScreen() async {
    final route = MaterialPageRoute(builder: (context) => AddTodoScreen());
    Navigator.of(context).push(route);
    final result = await route.popped;
    if (result != null && result is Map<String, String>) {
      context.read<TodoListProvider>().addTodoItem(
        result["title"]!,
        result["description"] ?? "",
      );
    }
  }

  void navigateToDefineScreen() async {
    final route = MaterialPageRoute(builder: (context) => DefineScreen());
    Navigator.of(context).push(route);
  }

  void navigateToNotesScreen() async {
    final route = MaterialPageRoute(builder: (context) => NotesScreen());
    Navigator.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    final hasTodos = context.watch<TodoListProvider>().todoItems.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 3),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(bottom: 8),
            child: AppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  onPressed: () async {
                    try {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                          title: const Text("Are you sure?"),
                          actions: [
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await auth.signOut();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("You have to login again."),
                                  ),
                                );
                              },
                              child: Text("Log out"),
                            ),
                          ],
                        ),
                      );
                    } catch (e) {
                      // ignore: avoid_print
                      print(e.toString());
                    }
                  },
                  icon: Icon(Icons.logout_outlined),
                ),
              ],
              title: Padding(
                padding: const EdgeInsets.only(left: 38.0),
                child: Center(
                  child: Text(
                    "todo_list".tr(),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: !hasTodos ? buildEmptyState() : buildTodoList(context),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addTodoScreen",
            elevation: 0,
            onPressed: navigateToAddTodoScreen,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          SizedBox(height: 35),
          FloatingActionButton(
            heroTag: "DefineScreen",
            elevation: 0,
            onPressed: navigateToDefineScreen,
            backgroundColor: Colors.black,
            child: const Icon(Icons.book, color: Colors.white),
          ),
          SizedBox(height: 35),
          FloatingActionButton(
            heroTag: "NotesScreen",
            elevation: 0,
            onPressed: navigateToNotesScreen,
            backgroundColor: Colors.black,
            child: const Icon(Icons.notes_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 64,
          color: Colors.grey[300],
          semanticLabel: '',
        ),
        const SizedBox(height: 16),
        Text(
          "no_task".tr(),
          style: TextStyle(fontSize: 24, color: Colors.grey[500]),
        ),
      ],
    ),
  );
  Widget buildTodoList(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, provider, _) {
        final todoItems = provider.todoItems;
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemCount: todoItems.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = todoItems[index];
            final isCompleted = item.asTodoItem?.isCompleted ?? false;
            return Dismissible(
              key: Key(item.title),
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: Icon(Icons.delete_outline, color: Colors.red[300]),
              ),
              onDismissed: (direction) => provider.deleteTodoItem(index),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => provider.toggleTodoCompletion(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x08000000),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? Colors.blue[100]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: isCompleted
                                  ? Colors.blue[300]!
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.blue[600],
                                )
                              : null,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: isCompleted
                                      ? Colors.grey[500]
                                      : Colors.black87,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationThickness: 2,
                                ),
                              ),
                              if (item.content.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    item.content,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isCompleted
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
