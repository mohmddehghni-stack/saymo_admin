import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'ticket_detail_page.dart';

class TicketsPage extends StatefulWidget {
  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  List<dynamic> _tickets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => _loading = true);
    final t = await ApiService.getTickets();
    setState(() {
      _tickets = t;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تیکت‌ها'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadTickets),
        ],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : _tickets.isEmpty
          ? ListView(
              // ← ListView برای پشتیبانی از RefreshIndicator
              children: [
                SizedBox(height: 200),
                Center(
                  child: Text(
                    'هیچ تیکتی وجود ندارد',
                    style: TextStyle(fontFamily: 'Vazir'),
                  ),
                ),
              ],
            )
          : RefreshIndicator(
              onRefresh: _loadTickets,
              child: ListView.builder(
                itemCount: _tickets.length,
                itemBuilder: (_, i) {
                  final t = _tickets[i];
                  return ListTile(
                    title: Text(t['subject'] ?? ''),
                    subtitle: Text(
                      '${t['status']} - ${t['display_name'] ?? ''}',
                    ),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketDetailPage(
                            ticketId: t['id'],
                            subject: t['subject'] ?? '',
                          ),
                        ),
                      ).then((_) => _loadTickets());
                    },
                  );
                },
              ),
            ),
    );
  }
}
