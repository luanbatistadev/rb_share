import 'dart:math';

String generateRandomAlias() {
  final random = Random();

  // The combination of both is locale dependent too.
  return '${names[random.nextInt(names.length)]} ${languages[random.nextInt(languages.length)]}';
}

List<String> names = [
  'Adriani',
  'Guilherme C.',
  'André',
  'Fogaça',
  'Raul',
  'Carlos',
  'AlexRint',
  'Jaina',
  'Wanilk',
  'Priscila',
  'Renato',
  'Alexandre',
  'Mateus',
  'JapoNegro',
  'Claudete',
  'Weil',
  'Marco',
  'J. Lucas',
  'Gilberto',
  'Wesley',
  'Katia',
  'Luccão',
];

List<String> languages = [
  'Flutter',
  'Dart',
  'C#',
  'Java',
  'Kotlin',
  'Python',
  'JavaScript',
  'TypeScript',
  'C++',
  'Ruby',
  'Go',
  'Rust',
  'Swift',
  'Objective-C',
  'PHP',
  'HTML',
  'CSS',
  'SQL',
  'Shell',
  'PowerShell',
  'R',
  'Perl',
  'Scala',
  'Groovy',
  'Lua',
];
