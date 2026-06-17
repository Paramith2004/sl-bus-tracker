import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bus_route.dart';
import '../providers/bus_provider.dart';

class RouteDetailScreen extends StatelessWidget {
  final BusRoute route;

  const RouteDetailScreen({super.key, required this.route});

  Color _busTypeColor(String type) {
    switch (type) {
      case 'Super Luxury': return const Color(0xFFc9a84c);
      case 'Express': return const Color(0xFF4c9ac9);
      case 'Night Express': return const Color(0xFFa78bfa);
      default: return const Color(0xFF4caf79);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusProvider>();
    final isFav = provider.isFavorite(route.id);

    return Scaffold(
      backgroundColor: const Color(0xFF0a0a0a),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: const Color(0xFF0a0a0a),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? const Color(0xFFc9a84c) : Colors.grey,
                ),
                onPressed: () => context.read<BusProvider>().toggleFavorite(route.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [const Color(0xFFc9a84c).withOpacity(0.2), const Color(0xFF0a0a0a)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        Text('Route ${route.routeNumber}', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(child: Text(route.from, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Icon(Icons.arrow_forward, color: Color(0xFFc9a84c), size: 20),
                            ),
                            Expanded(child: Text(route.to, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold), textAlign: TextAlign.right)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Cards
                  Row(
                    children: [
                      _infoCard('📏', 'Distance', route.distance),
                      const SizedBox(width: 10),
                      _infoCard('⏱️', 'Duration', route.duration),
                      const SizedBox(width: 10),
                      _infoCard('🚏', 'Stops', '${route.stops.length}'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stops
                  _sectionTitle('🗺️ Route Stops'),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFc9a84c).withOpacity(0.2)),
                    ),
                    child: Column(
                      children: route.stops.asMap().entries.map((entry) {
                        final i = entry.key;
                        final stop = entry.value;
                        final isFirst = i == 0;
                        final isLast = i == route.stops.length - 1;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isFirst || isLast ? const Color(0xFFc9a84c) : Colors.grey[700],
                                      border: Border.all(
                                        color: isFirst || isLast ? const Color(0xFFc9a84c) : Colors.grey[600]!,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(width: 2, height: 30, color: Colors.grey[800]),
                                ],
                              ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stop,
                                    style: TextStyle(
                                      color: isFirst || isLast ? Colors.white : Colors.grey[400],
                                      fontWeight: isFirst || isLast ? FontWeight.bold : FontWeight.normal,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (isFirst) Text('Departure', style: TextStyle(color: const Color(0xFFc9a84c), fontSize: 11)),
                                  if (isLast) Text('Arrival', style: TextStyle(color: const Color(0xFFc9a84c), fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Schedules
                  _sectionTitle('🕒 Daily Schedules'),
                  const SizedBox(height: 12),
                  ...route.schedules.map((s) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.06)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _busTypeColor(s.busType).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _busTypeColor(s.busType).withOpacity(0.4)),
                          ),
                          child: Text(s.busType, style: TextStyle(color: _busTypeColor(s.busType), fontSize: 11, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Departs', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                  Text(s.departure, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                              Icon(Icons.arrow_forward, color: Colors.grey[700], size: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Arrives', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                  Text(s.arrival, style: const TextStyle(color: Color(0xFF4ade80), fontWeight: FontWeight.bold, fontSize: 15)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String emoji, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFc9a84c).withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(color: Color(0xFFc9a84c), fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: const TextStyle(color: Color(0xFFc9a84c), fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5));
  }
}