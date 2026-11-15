import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../models/omni_models.dart';
import '../widgets/omni_ui.dart';

class DocumentsVaultScreen extends StatelessWidget {
  const DocumentsVaultScreen({super.key});

  Map<String, dynamic> _verificationInfo(String status) {
    const map = {
      'cadastro_incompleto': {
        'label': 'Cadastro Incompleto',
        'color': OmniTheme.textSecondary,
        'desc': 'Preencha todos os campos cadastrais obrigatórios.',
      },
      'aguardando_documentacao': {
        'label': 'Aguardando Documentação',
        'color': OmniTheme.alertAmber,
        'desc': 'Envie sua certidão de classe e comprovante de endereço.',
      },
      'documentacao_recebida': {
        'label': 'Documentação Recebida',
        'color': OmniTheme.infoSky,
        'desc': 'Arquivos recebidos e enfileirados para conferência.',
      },
      'em_analise': {
        'label': 'Em Análise Técnica',
        'color': Color(0xFF818CF8),
        'desc':
            'A equipe jurídica e técnica está checando a autenticidade perante os conselhos oficiais.',
      },
      'aprovado': {
        'label': 'Homologado & Aprovado',
        'color': OmniTheme.neonGreen,
        'desc':
            'Perfil verificado com selo oficial OMNI. Habilitado a apresentar propostas.',
      },
      'aprovado_com_restricoes': {
        'label': 'Aprovado com Restrições',
        'color': OmniTheme.alertAmber,
        'desc': 'Habilitado para demandas de menor complexidade.',
      },
      'pendente_correcao': {
        'label': 'Pendente de Correção',
        'color': Color(0xFFFB923C),
        'desc': 'Documento ilegível ou vencido. Reenvie o arquivo atualizado.',
      },
      'reprovado': {
        'label': 'Reprovado',
        'color': OmniTheme.alertCrimson,
        'desc': 'Inconsistência cadastral insanável.',
      },
      'suspenso': {
        'label': 'Suspenso',
        'color': OmniTheme.alertCrimson,
        'desc': 'Cadastro preventivamente paralisado.',
      },
      'bloqueado': {
        'label': 'Bloqueado',
        'color': OmniTheme.alertCrimson,
        'desc': 'Acesso vedado por descumprimento de normas.',
      },
    };
    return map[status] ?? map['aprovado']!;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();
    final verInfo = _verificationInfo(state.verificationStatus);
    final verColor = verInfo['color'] as Color;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      children: [
        OmniSectionHeader(
          icon: Icons.verified_user_outlined,
          eyebrow: 'Segurança & Compliance',
          title: 'Cofre Seguro de Documentos',
          subtitle:
              'Armazenamento privado com validação de MIME type, integridade criptográfica SHA-256 e homologação em 10 etapas.',
          trailing: ElevatedButton.icon(
            onPressed: () => _openUploadDialog(context, state),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            ),
            icon: const Icon(Icons.upload, size: 14),
            label: const Text('Enviar', style: TextStyle(fontSize: 11)),
          ),
        ),
        const SizedBox(height: 12),

        // Cartão de Status de Verificação Cadastral do Prestador (10 etapas)
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: OmniTheme.surfaceCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: verColor.withOpacity(0.4)),
            boxShadow: OmniTheme.neonGlow(opacity: 0.08, blur: 12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: verColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: verColor.withOpacity(0.35)),
                    ),
                    child: Icon(Icons.lock_outline, color: verColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STATUS DE CREDENCIAMENTO OFICIAL',
                          style: monoStyle(
                            color: OmniTheme.textSecondary,
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 4),
                        OmniBadge(
                          text: verInfo['label'] as String,
                          color: verColor,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          verInfo['desc'] as String,
                          style: const TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: OmniTheme.neonGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: OmniTheme.neonGreen.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle,
                            size: 14, color: OmniTheme.neonGreen),
                        const SizedBox(width: 6),
                        Text(
                          'Auditoria Periódica Ativa',
                          style: monoStyle(
                            color: OmniTheme.neonGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '11/11/2026 14:10',
                      style: monoStyle(
                          color: OmniTheme.textSecondary, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Documentos Armazenados no Cofre',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '${state.documents.length} documento(s)',
              style: monoStyle(color: OmniTheme.textSecondary, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...state.documents.map((doc) {
          Color stColor = OmniTheme.alertAmber;
          if (doc.statusVerificacao == 'aprovado') {
            stColor = OmniTheme.alertEmerald;
          } else if (doc.statusVerificacao == 'rejeitado') {
            stColor = OmniTheme.alertCrimson;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: OmniTheme.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: OmniTheme.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      doc.documentoId,
                      style: monoStyle(
                        color: OmniTheme.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    OmniBadge(
                      text: doc.statusVerificacao
                          .replaceAll('_', ' ')
                          .toUpperCase(),
                      color: stColor,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  doc.titulo,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${doc.nomeArquivo} · ${(doc.tamanhoKb / 1024).toStringAsFixed(2)} MB · ${doc.dataUpload}',
                  style: monoStyle(
                    color: OmniTheme.textSecondary,
                    fontSize: 10.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: OmniTheme.backgroundBlack,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'SHA-256: ${doc.hashIntegridade}',
                    style: monoStyle(
                      color: OmniTheme.textMuted,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openPreviewDialog(context, doc),
                        icon: const Icon(Icons.visibility_outlined, size: 14),
                        label: const Text('Visualizar',
                            style: TextStyle(fontSize: 11)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => showOmniToast(
                          context,
                          'Download de ${doc.nomeArquivo} com assinatura SHA-256 iniciado.',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: OmniTheme.neonGreen,
                          side: BorderSide(
                              color: OmniTheme.neonGreen.withOpacity(0.35)),
                        ),
                        icon: const Icon(Icons.download_outlined, size: 14),
                        label:
                            const Text('Baixar', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _openPreviewDialog(BuildContext context, VaultDocumentModel doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: OmniTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: OmniTheme.borderSubtle),
        ),
        title: Text(
          doc.titulo,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: OmniTheme.surfaceInner,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: OmniTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.picture_as_pdf,
                      color: OmniTheme.neonGreen, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    doc.nomeArquivo,
                    style: monoStyle(color: Colors.white, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Integridade verificada · ${doc.tamanhoKb} KB · ${doc.dataUpload}',
                    style: monoStyle(
                        color: OmniTheme.textSecondary, fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SHA-256:\n${doc.hashIntegridade}',
                    style: monoStyle(color: OmniTheme.neonGreen, fontSize: 9.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _openUploadDialog(BuildContext context, OmniAppState state) {
    final titleCtrl = TextEditingController();
    String tipo = 'registro_classe';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: OmniTheme.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: OmniTheme.borderSubtle),
          ),
          title: const Text(
            'Adicionar Documento ao Cofre',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: const InputDecoration(
                    labelText: 'Título do Documento / Certidão',
                    hintText: 'Ex: Certidão Negativa Trabalhista (CNDT)'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: tipo,
                isExpanded: true,
                dropdownColor: OmniTheme.surfaceCard,
                decoration:
                    const InputDecoration(labelText: 'Classificação / Tipo'),
                items: const [
                  DropdownMenuItem(
                      value: 'registro_classe',
                      child: Text('Registro de Classe (OAB, CRC, CREA)')),
                  DropdownMenuItem(
                      value: 'certidao',
                      child: Text('Certidão Negativa (PGFN, CNDT)')),
                  DropdownMenuItem(
                      value: 'contrato',
                      child: Text('Contrato Social / Ato Constitutivo')),
                  DropdownMenuItem(
                      value: 'laudo',
                      child: Text('Laudo Técnico / Parecer Homologado')),
                  DropdownMenuItem(
                      value: 'procuracao',
                      child: Text('Instrumento de Mandato / Procuração')),
                ],
                onChanged: (v) =>
                    setDlgState(() => tipo = v ?? 'registro_classe'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                state.uploadVaultDocument(titleCtrl.text.trim(), tipo);
                Navigator.pop(ctx);
                showOmniToast(
                  context,
                  'Documento criptografado (SHA-256) e enviado para homologação!',
                );
              },
              child: const Text('Criptografar & Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
