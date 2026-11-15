import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/state/omni_state.dart';
import '../core/theme/omni_theme.dart';
import '../widgets/omni_ui.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<OmniAppState>();
    final orderMessages = state.messages
        .where((m) => m.ordemServicoId == state.activeChatOrderId)
        .toList();

    final currentOrder = state.orders.isNotEmpty
        ? state.orders.firstWhere(
            (o) => o.ordemServicoId == state.activeChatOrderId,
            orElse: () => state.orders.first,
          )
        : null;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: OmniSectionHeader(
            icon: Icons.chat_bubble_outline,
            eyebrow: 'Comunicação Segura',
            title: 'Chat Contextual da OS',
            subtitle:
                'Mensageria interna criptografada com rastreabilidade formal vinculada à Ordem de Serviço.',
            trailing: OmniBadge(text: state.activeChatOrderId, glow: true),
          ),
        ),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.orders.length,
            itemBuilder: (_, idx) {
              final ord = state.orders[idx];
              final active = ord.ordemServicoId == state.activeChatOrderId;
              return GestureDetector(
                onTap: () => state.openOrderChat(ord.ordemServicoId),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: active
                        ? OmniTheme.surfaceCardActive
                        : OmniTheme.surfaceCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: active
                          ? OmniTheme.neonGreen.withOpacity(0.6)
                          : OmniTheme.borderSubtle,
                    ),
                    boxShadow:
                        active ? OmniTheme.neonGlow(opacity: 0.14) : null,
                  ),
                  child: Text(
                    ord.ordemServicoId,
                    style: monoStyle(
                      color: active ? OmniTheme.neonGreen : Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        if (currentOrder != null)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF0D131F),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: OmniTheme.borderSubtle),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentOrder.clienteNome,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        currentOrder.tituloServico,
                        style: const TextStyle(
                          color: OmniTheme.textSecondary,
                          fontSize: 10.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const OmniBadge(
                  text: 'SIGILO CONTRATUAL',
                  icon: Icons.lock_outline,
                ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        Expanded(
          child: orderMessages.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Nenhuma mensagem trocada nesta Ordem de Serviço ainda. Inicie a conversa abaixo.',
                      textAlign: TextAlign.center,
                      style: monoStyle(
                          color: OmniTheme.textMuted, fontSize: 11),
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: orderMessages.length,
                  itemBuilder: (_, idx) {
                    final m = orderMessages[idx];
                    final isMe = m.remetentePapel == 'profissional';
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.82,
                        ),
                        decoration: BoxDecoration(
                          color: isMe
                              ? const Color(0xFF121F28)
                              : const Color(0xFF131924),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: Radius.circular(isMe ? 12 : 2),
                            bottomRight: Radius.circular(isMe ? 2 : 12),
                          ),
                          border: Border.all(
                            color: isMe
                                ? OmniTheme.neonGreen.withOpacity(0.35)
                                : OmniTheme.borderSubtle,
                          ),
                          boxShadow: isMe
                              ? OmniTheme.neonGlow(opacity: 0.08, blur: 10)
                              : null,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    m.remetenteNome,
                                    style: TextStyle(
                                      color: isMe
                                          ? OmniTheme.neonGreen
                                          : Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  m.dataEnvio,
                                  style: monoStyle(
                                    color: OmniTheme.textMuted,
                                    fontSize: 9.5,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              m.conteudo,
                              style: const TextStyle(
                                color: Color(0xFFE2E8F0),
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                            if (m.anexoNome != null) ...[
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                      color: OmniTheme.borderFaint),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.description_outlined,
                                        size: 13, color: OmniTheme.neonGreen),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        m.anexoNome!,
                                        style: monoStyle(
                                          color: OmniTheme.neonGreen,
                                          fontSize: 10,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (isMe) ...[
                              const SizedBox(height: 4),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.done_all,
                                  size: 14,
                                  color: OmniTheme.neonGreen,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(10, 8, 12, 10),
          decoration: const BoxDecoration(
            color: Color(0xFF0D131F),
            border: Border(top: BorderSide(color: OmniTheme.borderSubtle)),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () => _openAttachDialog(context, state),
                tooltip: 'Anexar documento ou laudo',
                icon: const Icon(
                  Icons.attach_file,
                  color: OmniTheme.textSecondary,
                  size: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 12.5),
                  decoration: const InputDecoration(
                    hintText: 'Mensagem registrada nos autos da OS...',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  final text = _msgCtrl.text.trim();
                  if (text.isEmpty) return;
                  state.sendChatMessage(state.activeChatOrderId, text);
                  _msgCtrl.clear();
                },
                style: IconButton.styleFrom(
                  backgroundColor: OmniTheme.neonGreen,
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.send, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _openAttachDialog(BuildContext context, OmniAppState state) {
    final fileCtrl = TextEditingController(text: 'minuta_acordo_revisada.pdf');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: OmniTheme.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: OmniTheme.borderSubtle),
        ),
        title: const Text(
          'Anexar Arquivo ao Chat da OS',
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
        ),
        content: TextField(
          controller: fileCtrl,
          style: monoStyle(color: Colors.white, fontSize: 12),
          decoration: const InputDecoration(
              labelText: 'Nome do documento / laudo (.pdf)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final fname = fileCtrl.text.trim();
              if (fname.isEmpty) return;
              state.sendChatMessage(
                state.activeChatOrderId,
                'Documento anexado formalmente nos autos da OS.',
                anexoNome: fname,
              );
              Navigator.pop(ctx);
              showOmniToast(context, 'Anexo $fname enviado com registro SHA-256!');
            },
            child: const Text('Enviar Anexo'),
          ),
        ],
      ),
    );
  }
}
