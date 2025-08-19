import 'package:app/Screens/define_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/add_to_do_screen.dart';
import 'Providers/todo_list_provider.dart';

void main() {
  debugProfileBuildsEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoListProvider()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: true, home: AppScreen()),
    );
  }
}

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});
  @override
  State<AppScreen> createState() => AppScreenState();
}

class AppScreenState extends State<AppScreen> {
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
              title: Center(
                child: const Text(
                  "To do List",
                  style: TextStyle(fontWeight: FontWeight.w500),
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
          "No task yet",
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
                            color: item.isCompleted
                                ? Colors.blue[100]
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: item.isCompleted
                                  ? Colors.blue[300]!
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: item.isCompleted
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
                                  color: item.isCompleted
                                      ? Colors.grey[500]
                                      : Colors.black87,
                                  decoration: item.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationThickness: 2,
                                ),
                              ),
                              if (item.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    item.description,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: item.isCompleted
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
