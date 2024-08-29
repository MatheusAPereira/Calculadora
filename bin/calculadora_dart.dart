import 'dart:io';

void main() {
  print('----- Calculadora -----\nDigite a expressão: ');
  String expressao = stdin.readLineSync()!;

  try {
    double resultado = calcular(expressao);
    print('Resultado: $resultado');
  } catch (e) {
    throw Exception('Expressão inválida');
  }
}

double calcular(String expressao) {
  List<String> tokens = [];

  for (var i=0; i < expressao.length && i >= 0;){
    if(testarDigito(expressao[i])){
      String digitos = unirDigitos(expressao, i);
      tokens.add(digitos);
      i += digitos.length; 
    } else {
      tokens.add(expressao[i]);
      i++;
    }
  }

  List<String> posfixa = converterParaPosfixa(tokens);

  return avaliarPosfixa(posfixa);
}

List<String> converterParaPosfixa(List<String> tokens) {
  List<String> posfixa = [];
  List<String> pilha = [];

  for (String token in tokens) {
    if (token.isEmpty) continue;
    if (token == '+' || token == '-' || token == '*' || token == '/') {
      while (pilha.isNotEmpty && precedencia(pilha.last) >= precedencia(token)) {
        posfixa.add(pilha.removeLast());
      }
      pilha.add(token);
    } else if (token == '(') {
      pilha.add(token);
    } else if (token == ')') {
      while (pilha.isNotEmpty && pilha.last != '(') {
        posfixa.add(pilha.removeLast());
      }
      pilha.removeLast();
    } else {
      posfixa.add(token);
    }
  }

  while (pilha.isNotEmpty) {
    posfixa.add(pilha.removeLast());
  }

  return posfixa;
}

int precedencia(String operador) {
  switch (operador) {
    case '+':
    case '-':
      return 1;
    case '*':
    case '/':
      return 2;
    default:
      return 0;
  }
}

double avaliarPosfixa(List<String> posfixa) {
  List<double> pilha = [];

  for (String token in posfixa) {
    if (token == '+' || token == '-' || token == '*' || token == '/') {
      if (pilha.length < 2) {
        throw Exception("Expressão inválida");
      }
      double num2 = pilha.removeLast();
      double num1 = pilha.removeLast();

      switch (token) {
        case '+':
          pilha.add(num1 + num2);
          break;
        case '-':
          pilha.add(num1 - num2);
          break;
        case '*':
          pilha.add(num1 * num2);
          break;
        case '/':
          if (num2 != 0) {
            pilha.add(num1 / num2);
          } else {
            throw Exception('Divisão por zero');
          }
          break;
      }
    } else {
      pilha.add(double.parse(token));
    }
  }

  return pilha.last;
}

bool testarDigito(String s) {
 return s.codeUnitAt(0) >= 48 && s.codeUnitAt(0) <= 57;
}

String unirDigitos(String expressao, int i){
 var resultado = '';
 while(i < expressao.length && testarDigito(expressao[i])){
 resultado += expressao[i];
 i++;
 }
 return resultado;
}