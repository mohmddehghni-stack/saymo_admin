import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TicketDetailPage extends StatefulWidget {
  final int ticketId;
  final String subject;
  TicketDetailPage({required this.ticketId, required this.subject});
  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPage> {
  Map<String, dynamic>? _ticket;
  List<dynamic> _replies = [];
  TextEditingController _msgCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await ApiService.getTicket(widget.ticketId);
    if (data != null)
      setState(() {
        _ticket = data['ticket'];
        _replies = data['replies'];
      });
  }

  void _reply() async {
    final ok = await ApiService.replyToTicket(
      widget.ticketId,
      _msgCtrl.text.trim(),
    );
    if (ok) {
      _msgCtrl.clear();
      _load();
    }
  }

  void _changeStatus(String status) async {
    await ApiService.updateTicketStatus(widget.ticketId, status);
    _load();
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'open':
        return 'باز';
      case 'in_progress':
        return 'پاسخ داده شده';
      case 'closed':
        return 'بسته شده';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeStatus,
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'open',
                child: Text('باز', style: TextStyle(fontFamily: 'Vazir')),
              ),
              PopupMenuItem(
                value: 'in_progress',
                child: Text(
                  'پاسخ داده شده',
                  style: TextStyle(fontFamily: 'Vazir'),
                ),
              ),
              PopupMenuItem(
                value: 'closed',
                child: Text('بسته شده', style: TextStyle(fontFamily: 'Vazir')),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (_ticket != null)
            ListTile(
              title: Text(_ticket!['subject']),
              subtitle: Text('وضعیت: ${_statusLabel(_ticket!['status'])}'),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _replies.length,
              itemBuilder: (_, i) {
                final r = _replies[i];
                return ListTile(
                  title: Text(r['display_name'] ?? ''),
                  subtitle: Text(r['message']),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: InputDecoration(hintText: 'پاسخ...'),
                  ),
                ),
                IconButton(onPressed: _reply, icon: Icon(Icons.send)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
