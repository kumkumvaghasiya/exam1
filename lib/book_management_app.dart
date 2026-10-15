
import 'package:flutter/material.dart';

class BookManagementApp extends StatelessWidget {
  const BookManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F5F2),
      ),
      home: const BookSplashScreen(),
    );
  }
}

// BOOK MODEL
class Book {
  final String name;
  final String author;
  final String price;
  final String category;
  final String description;

  const Book({
    required this.name,
    required this.author,
    required this.price,
    required this.category,
    required this.description,
  });
}

// SPLASH SCREEN
class BookSplashScreen extends StatefulWidget {
  const BookSplashScreen({super.key});

  @override
  State<BookSplashScreen> createState() => _BookSplashScreenState();
}

class _BookSplashScreenState extends State<BookSplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  Future<void> navigateToHome() async {
    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const BookHomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.menu_book,
                size: 75,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'BOOK MANAGEMENT',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Organize Your Book Collection',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 35),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// HOME SCREEN AND BOTTOM NAVIGATION
class BookHomeScreen extends StatefulWidget {
  const BookHomeScreen({super.key});

  @override
  State<BookHomeScreen> createState() => _BookHomeScreenState();
}

class _BookHomeScreenState extends State<BookHomeScreen> {
  int selectedIndex = 0;
  final List<Book> books = [];
  Book? selectedBook;

  void addBook(Book book) {
    setState(() {
      books.add(book);
      selectedBook = book;
      selectedIndex = 2;
    });
  }

  void selectBook(Book book) {
    setState(() {
      selectedBook = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BookDashboard(
        totalBooks: books.length,
        onAdd: () => setState(() => selectedIndex = 1),
        onView: () => setState(() => selectedIndex = 2),
      ),
      BookFormScreen(onSubmit: addBook),
      BookGridScreen(
        books: books,
        selectedBook: selectedBook,
        onBookTap: selectBook,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Book Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown.shade700,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() => selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Book Form',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view),
            selectedIcon: Icon(Icons.grid_on),
            label: 'Book Grid',
          ),
        ],
      ),
    );
  }
}

// HOME DASHBOARD
class BookDashboard extends StatelessWidget {
  final int totalBooks;
  final VoidCallback onAdd;
  final VoidCallback onView;

  const BookDashboard({
    super.key,
    required this.totalBooks,
    required this.onAdd,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your book collection in one place.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 25),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.library_books, size: 32),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Books',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$totalBooks',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add New Book'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onView,
              icon: const Icon(Icons.grid_view),
              label: const Text('View Book Grid'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// BOOK FORM
class BookFormScreen extends StatefulWidget {
  final ValueChanged<Book> onSubmit;

  const BookFormScreen({
    super.key,
    required this.onSubmit,
  });

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final authorController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;

  final List<String> categories = [
    'Education',
    'Fiction',
    'Biography',
    'Science',
    'Technology',
    'History',
    'Other',
  ];

  void submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final book = Book(
      name: nameController.text.trim(),
      author: authorController.text.trim(),
      price: priceController.text.trim(),
      category: selectedCategory!,
      description: descriptionController.text.trim(),
    );

    widget.onSubmit(book);

    nameController.clear();
    authorController.clear();
    priceController.clear();
    descriptionController.clear();

    setState(() {
      selectedCategory = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    authorController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Book Details',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            const SizedBox(height: 22),

            // BOOK NAME
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Book Name',
                prefixIcon: Icon(Icons.menu_book),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book name';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // AUTHOR NAME
            TextFormField(
              controller: authorController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Author Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter author name';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // PRICE
            TextFormField(
              controller: priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Book Price',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book price';
                }

                final price = double.tryParse(value.trim());

                if (price == null || !price.isFinite || price <= 0) {
                  return 'Enter a valid price greater than zero';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // CATEGORY
            DropdownButtonFormField<String>(
              value: selectedCategory,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select category';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // DESCRIPTION
            TextFormField(
              controller: descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter book details',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter book description';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Save Book'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// BOOK GRID AND DETAILS CARD
class BookGridScreen extends StatelessWidget {
  final List<Book> books;
  final Book? selectedBook;
  final ValueChanged<Book> onBookTap;

  const BookGridScreen({
    super.key,
    required this.books,
    required this.selectedBook,
    required this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Book Grid',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
              ),
              Chip(
                avatar: const Icon(Icons.library_books, size: 18),
                label: Text('${books.length} Books'),
              ),
            ],
          ),
        ),

        // DYNAMIC GRIDVIEW
        Expanded(
          child: books.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 65,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'No books added yet.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            itemCount: books.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.05,
            ),
            itemBuilder: (context, index) {
              final book = books[index];
              final isSelected = selectedBook == book;

              return Card(
                elevation: isSelected ? 5 : 2,
                color: isSelected
                    ? Colors.brown.shade50
                    : Colors.white,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onBookTap(book),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu_book,
                          size: 42,
                          color: Colors.brown.shade400,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          book.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          book.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${book.price}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // SELECTED BOOK DETAILS CARD
        if (selectedBook != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
            child: Card(
              color: Colors.brown.shade50,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.brown,
                          size: 25,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Book Details',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    detailRow('Book Name', selectedBook!.name),
                    detailRow('Author', selectedBook!.author),
                    detailRow('Price', '₹${selectedBook!.price}'),
                    detailRow('Category', selectedBook!.category),
                    detailRow('Description', selectedBook!.description),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
