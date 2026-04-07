

class DatabaseHelper{
  static const _dbName = 'my_database.db';
  static const _dbVersion = 1;

  static const table = 'myTable';
  static const id = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';


  Future<void> init() async{
     final folder = await getApplic.ationDocumentDirectory();
     final path = join(folder.path, _dbName);
     _database = await openDatabase(
      path, 
      version: _dbVersion, 
      onCreate: _onCreate, 
      );
  }
 
  Future<void> _onCreate(Database db, int version) async {
    final sql = '''
CREATE TABLE $table ( 
$columnId INTEGER PRIMARY KEY, 
$columnName TEXT NOT NULL,
$columnAge INTEGER NOT NUll
)
''';
    await db.execute(sql);
  
  }
}