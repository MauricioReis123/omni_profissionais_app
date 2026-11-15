import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../models/opportunity_model.dart';
import 'omni_ui.dart';

void showClientRequestSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => const _ClientRequestSheet(),
  );
}

class _ClientRequestSheet extends StatefulWidget {
  const _ClientRequestSheet();

  @override
  State<_ClientRequestSheet> createState() => _ClientRequestSheetState();
}

class _ClientRequestSheetState extends State<_ClientRequestSheet> {
  int _step = 1;
  String _categoria = 'contabil_tributario';
  String _quandoPrecisa = 'Esta semana';
  String _modalidade = 'remoto';

  final _tituloCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _cidadeCtrl = TextEditingController(text: 'São Paulo');
  final _estadoCtrl = TextEditingController(text: 'SP');
  final _orcMinCtrl = TextEditingController(text: '5000');
  final _orcMaxCtrl = TextEditingController(text: '12000');
  final _nomeCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final List<String> _quickUrgencyOptions = const [
    'Para hoje ou amanhã',
    'Esta semana',
    'Nos próximos 15 dias',
    'Apenas pesquisando preços',
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.88,
        minChildSize: 0.55,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFF0E131D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            border:
                Border(top: BorderSide(color: OmniTheme.neonGreen, width: 1.5)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(18),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ETAPA $_step DE 3 · ESTILO GETNINJAS',
                          style: monoStyle(
                            color: OmniTheme.neonGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Solicitar um Profissional / Serviço',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close,
                        color: OmniTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [1, 2, 3].map((s) {
                  final active = _step >= s;
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: s < 3 ? 6 : 0),
                      decoration: BoxDecoration(
                        color: active
                            ? OmniTheme.neonGreen
                            : OmniTheme.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // PASSO 1: Categoria, Título e Descrição (igual ClientRequestModal.tsx)
              if (_step == 1) ...[
                DropdownButtonFormField<String>(
                  value: _categoria,
                  isExpanded: true,
                  dropdownColor: OmniTheme.surfaceCard,
                  decoration: const InputDecoration(
                    labelText: 'Qual categoria de serviço você precisa?',
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'juridico',
                        child: Text('Jurídico & Compliance (Advocacia)')),
                    DropdownMenuItem(
                        value: 'contabil_tributario',
                        child: Text('Contábil & Tributário (Contadores)')),
                    DropdownMenuItem(
                        value: 'administracao_gestao',
                        child: Text('Administração & Gestão Empresarial')),
                    DropdownMenuItem(
                        value: 'financeiro',
                        child: Text('Consultoria Financeira & Perícias')),
                    DropdownMenuItem(
                        value: 'cartorario_notarial',
                        child: Text('Serviços Cartorários & Despachantes')),
                    DropdownMenuItem(
                        value: 'engenharia_arquitetura',
                        child: Text('Engenharia, Laudos & Avaliações')),
                    DropdownMenuItem(
                        value: 'tecnologia_sistemas',
                        child: Text('Tecnologia, Sistemas & Automação')),
                  ],
                  onChanged: (v) =>
                      setState(() => _categoria = v ?? 'contabil_tributario'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _tituloCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Título resumido do pedido',
                    hintText:
                        'Ex: Regularização de CNPJ e cálculo de passivo fiscal',
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Descreva o que precisa ser feito:',
                    hintText:
                        'Explique o problema, prazos e detalhes importantes...',
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_descCtrl.text.trim().isEmpty) {
                      _descCtrl.text =
                          'Necessito de atendimento técnico especializado com orçamento detalhado.';
                    }
                    setState(() => _step = 2);
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Avançar para Localização & Prazos'),
                ),
              ],

              // PASSO 2: Urgência, Localização & Orçamento
              if (_step == 2) ...[
                const Text(
                  'Para quando você precisa do serviço?',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.35,
                  ),
                  itemCount: _quickUrgencyOptions.length,
                  itemBuilder: (_, idx) {
                    final opt = _quickUrgencyOptions[idx];
                    final active = _quandoPrecisa == opt;
                    return GestureDetector(
                      onTap: () => setState(() => _quandoPrecisa = opt),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFF121C29)
                              : OmniTheme.backgroundBlack,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: active
                                ? OmniTheme.neonGreen
                                : OmniTheme.borderFaint,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            opt,
                            style: TextStyle(
                              color: active
                                  ? OmniTheme.neonGreen
                                  : const Color(0xFFCBD5E1),
                              fontSize: 11,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: _cidadeCtrl,
                        decoration: const InputDecoration(labelText: 'Cidade'),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _estadoCtrl,
                        maxLength: 2,
                        decoration: const InputDecoration(
                            labelText: 'UF', counterText: ''),
                        style: monoStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _modalidade,
                  dropdownColor: OmniTheme.surfaceCard,
                  decoration: const InputDecoration(labelText: 'Modalidade'),
                  items: const [
                    DropdownMenuItem(value: 'remoto', child: Text('Remoto')),
                    DropdownMenuItem(value: 'hibrido', child: Text('Híbrido')),
                    DropdownMenuItem(
                        value: 'presencial', child: Text('Presencial')),
                  ],
                  onChanged: (v) =>
                      setState(() => _modalidade = v ?? 'remoto'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _orcMinCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Orçamento Mín. (R\$)'),
                        style: monoStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _orcMaxCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Orçamento Máx. (R\$)'),
                        style: monoStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _step = 1),
                      icon: const Icon(Icons.arrow_back, size: 15),
                      label: const Text('Voltar'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => setState(() => _step = 3),
                        icon: const Icon(Icons.arrow_forward, size: 15),
                        label: const Text('Avançar para Contatos'),
                      ),
                    ),
                  ],
                ),
              ],

              // PASSO 3: Dados do Contratante & Publicação
              if (_step == 3) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: OmniTheme.surfaceInput,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: OmniTheme.neonGreen.withOpacity(0.35)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user_outlined,
                          color: OmniTheme.neonGreen, size: 18),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Seus dados são protegidos: apenas até 4 profissionais qualificados poderão desbloquear seu contato mediante moedas de crédito.',
                          style: TextStyle(
                              color: OmniTheme.textSecondary, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nomeCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Seu Nome Completo ou Razão Social',
                    hintText: 'Ex: Roberto Alencar (Diretoria Comercial)',
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _whatsappCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp para Contato Direto',
                    hintText: 'Ex: (11) 98844-2211',
                  ),
                  style: monoStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-mail para Recebimento de Propostas',
                    hintText: 'Ex: roberto.alencar@empresa.com.br',
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => setState(() => _step = 2),
                      icon: const Icon(Icons.arrow_back, size: 15),
                      label: const Text('Voltar'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow:
                              OmniTheme.neonGlow(opacity: 0.25, blur: 12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final minVal =
                                double.tryParse(_orcMinCtrl.text) ?? 5000;
                            final maxVal =
                                double.tryParse(_orcMaxCtrl.text) ?? 12000;
                            final nome = _nomeCtrl.text.trim().isEmpty
                                ? 'Empresa Solicitante'
                                : _nomeCtrl.text.trim();
                            final wpp = _whatsappCtrl.text.trim().isEmpty
                                ? '(11) 99400-8821'
                                : _whatsappCtrl.text.trim();
                            final wppDigits =
                                wpp.replaceAll(RegExp(r'\D'), '');
                            final email = _emailCtrl.text.trim().isEmpty
                                ? 'contato@empresa-demandante.com.br'
                                : _emailCtrl.text.trim();
                            final title = _tituloCtrl.text.trim().isEmpty
                                ? 'Atendimento Especializado em ${_cidadeCtrl.text}/${_estadoCtrl.text}'
                                : _tituloCtrl.text.trim();
                            final isUrgent = _quandoPrecisa
                                    .toLowerCase()
                                    .contains('hoje') ||
                                _quandoPrecisa
                                    .toLowerCase()
                                    .contains('semana');

                            final id =
                                'SOL-NINJA-${DateTime.now().millisecondsSinceEpoch % 9000 + 1000}';
                            final opp = OpportunityModel(
                              solicitacaoId: id,
                              origemSolicitacao: 'solicitacao_direta',
                              categoria: _categoria,
                              subcategoria: 'Solicitação Direta de Cliente',
                              especialidade: title,
                              titulo: title,
                              descricaoResumida: _descCtrl.text.trim(),
                              cidade: _cidadeCtrl.text.trim(),
                              estado: _estadoCtrl.text.trim().toUpperCase(),
                              modalidade: _modalidade,
                              urgencia: isUrgent ? 'alta' : 'media',
                              prazoEstimadoDias: 20,
                              orcamentoMin: minVal,
                              orcamentoMax: maxVal,
                              compatibilidadeScore: 96,
                              dataPublicacao: 'Hoje',
                              documentosExigidos: [
                                'Habilitação do Conselho de Classe'
                              ],
                              clienteNomeAnonimizado:
                                  '${nome.split(' ').first} (Empresa Solicitante)',
                              liberacaoFinanceira: true,
                              custoMoedas: isUrgent ? 45 : 35,
                              maxProfissionaisPermitidos: 4,
                              profissionaisJaDesbloquearam: 0,
                              clienteTelefoneReal: wpp,
                              clienteWhatsappReal: wppDigits.isEmpty
                                  ? '5511994008821'
                                  : wppDigits,
                              clienteEmailReal: email,
                              clienteEnderecoReal:
                                  '${_cidadeCtrl.text}/${_estadoCtrl.text.toUpperCase()}',
                              quandoPrecisa: _quandoPrecisa,
                            );
                            context
                                .read<OmniAppState>()
                                .addClientOpportunity(opp);
                            Navigator.pop(context);
                            showOmniToast(
                              context,
                              "Pedido '$id' publicado no Marketplace OMNI!",
                            );
                          },
                          icon: const Icon(Icons.auto_awesome, size: 16),
                          label: const Text('Publicar Pedido no OMNI'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
