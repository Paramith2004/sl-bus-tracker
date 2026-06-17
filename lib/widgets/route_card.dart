import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bus_route.dart';
import '../providers/bus_provider.dart';

class RouteCard extends StatelessWidget {
  final BusRoute route;
  final VoidCallback onTap;

  const RouteCard({super.key, required this.route, required this.onTap});

  Color _typeColor(String type) {
    switch (type) {
      case 'Express': return const Color(0xFF4c9ac9);
      case 'Long Distance': return const Color(0xFFc94c7a);
      default: return const Color(0xFF4caf79);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BusProvider>();
    final isFav = provider.isFavorite(route.id);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFc9a84c).withOpacity(0.15)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  // Route number badge
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: const Color(0xFFc9a84c).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFc9a84c).withOpacity(0.4)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🚌', style: TextStyle(fontSize: 16)),
                        Text(route.routeNumber, style: const TextStyle(color: Color(0xFFc9a84c), fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  // From → To
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(route.from, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.arrow_forward, color: Color(0xFFc9a84c), size: 16),
                            ),
                            Expanded(
                              child: Text(route.to, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15), textAlign: TextAlign.right),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _infoChip(Icons.straighten, route.distance),
                            const SizedBox(width: 8),
                            _infoChip(Icons.access_time, route.duration),
                            const SizedBox(width: 8),
                            _infoChip(Icons.place, '${route.stops.length} stops'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Favorite button
                  GestureDetector(
                    onTap: () => context.read<BusProvider>().toggleFavorite(route.id),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isFav ? const Color(0xFFc9a84c).withOpacity(0.2) : Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFc9a84c) : Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _typeColor(route.type).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _typeColor(route.type).withOpacity(0.4)),
                    ),
                    child: Text(route.type, style: TextStyle(color: _typeColor(route.type), fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  Text('${route.schedules.length} departures daily', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Row(
                    children: [
                      Text('View Details', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.grey[600], size: 16),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 12),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
      ],
    );
  }
}