import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  static Database? _database;

  // Table and column constants
  static const String _tableName = 'notes';
  static const String _columnId = 'id';
  static const String _columnTitle = 'title';
  static const String _columnDescription = 'description';
  static const String _columnDate = 'date';
  static const String _columnDeadline = 'deadline'; // Add deadline column

  /// Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'notes.db');
      print('Database path: $path'); // Debug log for database path

      return await openDatabase(
        path,
        version: 2, // Increment version to trigger onUpgrade
        onCreate: (db, version) async {
          print('Creating notes table'); // Debug log for table creation
          await db.execute('''
            CREATE TABLE $_tableName (
              $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
              $_columnTitle TEXT,
              $_columnDescription TEXT,
              $_columnDate TEXT,
              $_columnDeadline TEXT
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 2) {
            await db.execute('ALTER TABLE $_tableName ADD COLUMN $_columnDeadline TEXT');
          }
        },
      );
    } catch (e) {
      print('Error initializing database: $e'); // Debug log for initialization errors
      rethrow;
    }
  }

  /// Add a new note to the database
  Future<int> addNote(String title, String description, String date, String? deadline) async {
    try {
      final db = await database;
      final result = await db.insert(
        _tableName,
        {
          _columnTitle: title,
          _columnDescription: description,
          _columnDate: date,
          _columnDeadline: deadline,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Inserted note with ID: $result'); // Debug log for inserted note ID
      return result;
    } catch (e) {
      print('Error inserting note: $e'); // Debug log for insertion errors
      rethrow;
    }
  }

  /// Retrieve all notes from the database
  Future<List<Map<String, dynamic>>> getNotes() async {
    try {
      final db = await database;
      final notes = await db.query(
        _tableName,
        orderBy: '$_columnDate DESC',
      );
      print('Fetched notes: $notes'); // Debug log for fetched notes
      return notes;
    } catch (e) {
      print('Error fetching notes: $e'); // Debug log for fetching errors
      rethrow;
    }
  }

  /// Delete a note by its ID
  Future<int> deleteNoteById(int id) async {
    try {
      final db = await database;
      final result = await db.delete(
        _tableName,
        where: '$_columnId = ?',
        whereArgs: [id],
      );
      print('Deleted note with ID: $id'); // Debug log for deletion
      return result;
    } catch (e) {
      print('Error deleting note: $e'); // Debug log for deletion errors
      rethrow;
    }
  }

  /// Update a note by its ID
  Future<int> updateNote(
      int id, String title, String description, String date, String? deadline) async {
    try {
      final db = await database;
      final result = await db.update(
        _tableName,
        {
          _columnTitle: title,
          _columnDescription: description,
          _columnDate: date,
          _columnDeadline: deadline,
        },
        where: '$_columnId = ?',
        whereArgs: [id],
      );
      print('Updated note with ID: $id'); // Debug log for update
      return result;
    } catch (e) {
      print('Error updating note: $e'); // Debug log for update errors
      rethrow;
    }
  }

  /// Clear all notes from the database
  Future<int> clearNotes() async {
    try {
      final db = await database;
      final result = await db.delete(_tableName);
      print('Cleared all notes from table'); // Debug log for clearing table
      return result;
    } catch (e) {
      print('Error clearing notes: $e'); // Debug log for clearing errors
      rethrow;
    }
  }

  /// Close the database
  Future<void> closeDatabase() async {
    try {
      final db = _database;
      if (db != null) {
        await db.close();
        print('Database closed'); // Debug log for database close
        _database = null;
      }
    } catch (e) {
      print('Error closing database: $e'); // Debug log for close errors
      rethrow;
    }
  }
}