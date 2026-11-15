import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OmniApiService {
  final String baseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  OmniApiService({
    this.baseUrl = 'https://seudominio.com.br/wp-admin/admin-ajax.php',
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await _storage.read(key: 'omni_auth_token');
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Ponto de entrada para requisições no omni_profissionais_router
  Future<Map<String, dynamic>> callOperation(String operacao, [Map<String, dynamic>? params]) async {
    final headers = await _getHeaders();
    final body = {
      'action': 'omni_profissionais_router',
      'operacao': operacao,
      ...?params?.map((k, v) => MapEntry(k, v.toString())),
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          'sucesso': false,
          'codigo': response.statusCode,
          'mensagem': 'Erro de comunicação com o servidor: HTTP ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'sucesso': false,
        'codigo': 500,
        'mensagem': 'Falha de conexão: $e',
      };
    }
  }

  /// Autenticação e Armazenamento Seguro de Token
  Future<bool> login(String email, String senha) async {
    final res = await callOperation('autenticacao_login', {
      'email': email,
      'senha': senha,
    });

    if (res['sucesso'] == true && res['token'] != null) {
      await _storage.write(key: 'omni_auth_token', value: res['token']);
      await _storage.write(key: 'omni_user_data', value: jsonEncode(res['usuario']));
      return true;
    }
    return false;
  }

  /// Geração de Pagamento Pix com Mercado Pago
  Future<Map<String, dynamic>> gerarPixOrdemServico(String ordemServicoId, double valor) async {
    return await callOperation('financeiro_criar_pix', {
      'ordem_servico_id': ordemServicoId,
      'valor': valor.toString(),
    });
  }

  /// Consultar Carteira de Moedas (Estilo GetNinjas)
  Future<Map<String, dynamic>> consultarCarteiraMoedas(String profissionalId) async {
    return await callOperation('moedas_consultar_carteira', {
      'profissional_id': profissionalId,
    });
  }

  /// Desbloquear Contato de Cliente com Moedas
  Future<Map<String, dynamic>> desbloquearLead(String solicitacaoId, String profissionalId) async {
    return await callOperation('leads_desbloquear_contato', {
      'solicitacao_id': solicitacaoId,
      'profissional_id': profissionalId,
    });
  }

  /// Acionar Garantia Ninja (Estorno de Moedas)
  Future<Map<String, dynamic>> solicitarEstornoMoedas(String solicitacaoId, String profissionalId) async {
    return await callOperation('leads_solicitar_reembolso', {
      'solicitacao_id': solicitacaoId,
      'profissional_id': profissionalId,
    });
  }

  /// Listar Vagas PJ / Freelancer / CLT
  Future<Map<String, dynamic>> listarVagas() async {
    return await callOperation('vagas_listar');
  }
}
