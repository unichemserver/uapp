import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:uapp/core/utils/range_date_picker.dart' as drp;

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  
  // State management untuk data dari API
  DashboardData? dashboardData;
  bool isLoading = true;
  String? errorMessage;
  
  final currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp. ',
    decimalDigits: 0,
  );

  final List<Color> gradientColors = [
    const Color(0xFF0D47A1),
    const Color(0xFF1E88E5),
  ];
  
  // Controllers
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTopButton = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset >= 300) {
          _showBackToTopButton = true;
        } else {
          _showBackToTopButton = false;
        }
      });
    });

    // Load initial data from API
    _loadDashboardData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Simulate API call - replace with your actual API service
  Future<void> _loadDashboardData({DateTimeRange? dateRange}) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Simulate API response - replace with actual API call
      final apiResponse = await _fetchDashboardDataFromAPI(dateRange);
      
      setState(() {
        dashboardData = apiResponse;
        isLoading = false;
      });

      // Start animation after data loaded
      _animationController.forward();

    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat data: $e';
      });
    }
  }

  // Mock API call - replace with your actual API implementation
  Future<DashboardData> _fetchDashboardDataFromAPI(DateTimeRange? dateRange) async {
    // This would be your actual API call
    // Example: final response = await ApiService.getDashboardData(dateRange);
    
    // Simulate dynamic data based on date range
    final defaultDateRange = dateRange ?? DateTimeRange(
      start: DateTime(2025, 5, 19),
      end: DateTime(2025, 6, 19),
    );

    // Simulate different data based on date range (for demo purposes)
    final daysDiff = defaultDateRange.end.difference(defaultDateRange.start).inDays;
    final multiplier = (daysDiff / 30).clamp(0.5, 2.0);

    return DashboardData(
      dateRange: defaultDateRange,
      totalPenjualan: (560 * multiplier).round(),
      distribusiKecamatan: (48 * multiplier).round(),
      rataRataPenjualanPerHari: 23.3 * multiplier,
      distribusiKabupaten: (8 * multiplier).round(),
      distribusiProvinsi: (9 * multiplier).round(),
      totalPendapatan: (80322800 * multiplier).round(),
      itemTerjual: [
        ItemData('GRADE 1', 650 * multiplier, '${(98 * multiplier).round()} BAL'),
        ItemData('GRADE 2', 430 * multiplier, '${(40 * multiplier).round()} BAL'),
        ItemData('GRADE 3', 210 * multiplier, '${(13 * multiplier).round()} BAL'),
        ItemData('GRADE 4', 190 * multiplier, '${(8 * multiplier).round()} BAL'),
      ],
      performaPenjualan: [
        PerformaData('ANGGARA', 261 * multiplier),
        PerformaData('ANDREAS', 171 * multiplier),
        PerformaData('KRISMAN', 128 * multiplier),
      ],
      penjualanHarian: _generateDynamicSalesData(defaultDateRange),
    );
  }

  // Generate dynamic sales data based on date range
  List<PenjualanHarian> _generateDynamicSalesData(DateTimeRange dateRange) {
    List<PenjualanHarian> salesData = [];
    DateTime currentDate = dateRange.start;
    
    while (currentDate.isBefore(dateRange.end) || currentDate.isAtSameMomentAs(dateRange.end)) {
      // Simulate varying sales data
      const baseValue = 15.0;
      final variation = (currentDate.weekday == DateTime.saturday || currentDate.weekday == DateTime.sunday) 
          ? baseValue * 0.7  // Lower sales on weekends
          : baseValue + (currentDate.day % 7) * 2; // Varying weekday sales
      
      salesData.add(PenjualanHarian(currentDate, variation));
      currentDate = currentDate.add(const Duration(days: 1));
    }
    
    return salesData.take(30).toList(); // Limit to 30 days for chart readability
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              backgroundColor: const Color(0xFF1976D2),
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: const Text(
        'Dashboard',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3748),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF718096)),
          onPressed: () => _loadDashboardData(dateRange: dashboardData?.dateRange),
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Color(0xFF718096)),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (errorMessage != null) {
      return _buildErrorState();
    }

    if (dashboardData == null) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateRangeSelector(),
          _buildDashboardTitle(),
          _buildMetricsGrid(),
          _buildPendapatanCard(),
          _buildItemTerjualChart(),
          _buildPerformaPenjualanChart(),
          // _buildPenjualanHarianChart(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
          ),
          SizedBox(height: 16),
          Text(
            'Memuat data dashboard...',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          Text(
            errorMessage!,
            style: const TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _loadDashboardData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 64,
            color: Color(0xFF718096),
          ),
          SizedBox(height: 16),
          Text(
            'Tidak ada data untuk ditampilkan',
            style: TextStyle(
              color: Color(0xFF718096),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: drp.DateRangePickerUtils.buildDateRangeSelector(
              dateRange: dashboardData!.dateRange,
              onDateRangeChanged: (DateTimeRange newRange) async {
                // Update date range and reload data from API
                await _loadDashboardData(dateRange: newRange);
              },
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardTitle() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1976D2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1976D2).withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CANVASING DASHBOARD',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.analytics_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildMetricCard(
            title: 'Total Penjualan',
            value: dashboardData!.totalPenjualan.toString(),
            icon: Icons.shopping_cart_outlined,
            color: const Color(0xFF1976D2),
          ),
          _buildMetricCard(
            title: 'Distribusi per Kecamatan',
            value: dashboardData!.distribusiKecamatan.toString(),
            icon: Icons.location_on_outlined,
            color: const Color(0xFF00CEC9),
          ),
        ],
      ),
    );
  }

  Widget _buildPendapatanCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF64B5F6),
              Color(0xFF0D47A1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1976D2).withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.attach_money, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  'Total Pendapatan',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              currencyFormat.format(dashboardData!.totalPendapatan),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '+12% dari bulan lalu',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_upward, color: Colors.green, size: 12),
                    SizedBox(width: 2),
                    Text(
                      '8%',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTerjualChart() {
    if (dashboardData!.itemTerjual.isEmpty) {
      return _buildEmptyChartState('Tidak ada data item terjual');
    }

    // Dynamically calculate maxY based on data
    final maxValue = dashboardData!.itemTerjual
        .map((item) => item.value)
        .reduce((a, b) => a > b ? a : b);
    final dynamicMaxY = (maxValue * 1.2).ceilToDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Item Terjual',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF718096),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceEvenly,
                    maxY: dynamicMaxY,
                    minY: 0,
                    barGroups: _buildDynamicBarGroups(),
                    titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        axisNameSize: 0,
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  color: Color(0xFF718096),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                          reservedSize: 35,
                          interval: dynamicMaxY / 5, // Dynamic interval
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameSize: 0,
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < dashboardData!.itemTerjual.length) {
                              final item = dashboardData!.itemTerjual[index];
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.label,
                                      style: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                          reservedSize: 45,
                        ),
                      ),
                      rightTitles: const AxisTitles(
                        axisNameSize: 0,
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        axisNameSize: 0,
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: dynamicMaxY / 5,
                      getDrawingHorizontalLine: (value) {
                        return const FlLine(
                          color: Color(0xFFEDF2F7),
                          strokeWidth: 1,
                        );
                      },
                      drawVerticalLine: false,
                    ),
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: const Color(0xFF1F2937),
                        tooltipRoundedRadius: 12,
                        tooltipPadding: const EdgeInsets.all(12),
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          final item = dashboardData!.itemTerjual[groupIndex];
                          return BarTooltipItem(
                            '${item.name}\n${item.value.toInt()} items\n${item.label}',
                            const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildDynamicBarGroups() {
    return dashboardData!.itemTerjual.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: item.value,
            width: 24,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xFF1E88E5),
                Color(0xFF0D47A1),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildPerformaPenjualanChart() {
    if (dashboardData!.performaPenjualan.isEmpty) {
      return _buildEmptyChartState('Tidak ada data performa penjualan');
    }

    final maxPerforma = dashboardData!.performaPenjualan
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Performa Penjualan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Color(0xFF718096),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: dashboardData!.performaPenjualan.length * 70.0 + 32,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: dashboardData!.performaPenjualan.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final data = dashboardData!.performaPenjualan[index];
                  
                  final animation = Tween<double>(
                    begin: 0.0,
                    end: data.value / maxPerforma,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      index * 0.2,
                      0.6 + index * 0.2,
                      curve: Curves.easeOut,
                    ),
                  ));
                  
                  return AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4A5568),
                                ),
                              ),
                              Text(
                                data.value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Stack(
                            children: [
                              Container(
                                height: 10,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDF2F7),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              Container(
                                height: 10,
                                width: MediaQuery.of(context).size.width * animation.value * 0.7,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF0D47A1), Color(0xFF1E88E5)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPenjualanHarianChart() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.1),
  //             spreadRadius: 1,
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   'Grafik 7 Hari Terakhir Penjualan',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Color(0xFF2D3748),
  //                   ),
  //                 ),
  //                 Row(
  //                   children: [
  //                     IconButton(
  //                       icon: const Icon(Icons.refresh, color: Color(0xFF718096), size: 20),
  //                       onPressed: () {},
  //                     ),
  //                     IconButton(
  //                       icon: const Icon(Icons.file_download_outlined, color: Color(0xFF718096), size: 20),
  //                       onPressed: () {},
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             height: 220,
  //             child: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: LineChart(
  //                 LineChartData(
  //                   lineTouchData: LineTouchData(
  //                     enabled: true, // Add this explicit property for 0.66.2
  //                     touchTooltipData: LineTouchTooltipData(
  //                       tooltipBgColor: const Color(0xFF2D3748),
  //                       tooltipRoundedRadius: 8,
  //                       getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
  //                         return touchedBarSpots.map((barSpot) {
  //                           final index = barSpot.x.toInt();
  //                           if (index >= 0 && index < dashboardData.penjualanHarian.length) {
  //                             final data = dashboardData.penjualanHarian[index];
  //                             return LineTooltipItem(
  //                               '${DateFormat('dd/MM').format(data.date)}\n${data.value.toInt()} penjualan',
  //                               const TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             );
  //                           }
  //                           return null;
  //                         }).toList();
  //                       },
  //                     ),
  //                   ),
  //                   gridData: FlGridData(
  //                     show: true,
  //                     drawVerticalLine: false,
  //                     horizontalInterval: 5,
  //                     getDrawingHorizontalLine: (value) {
  //                       return const FlLine(
  //                         color:  Color(0xFFEDF2F7),
  //                         strokeWidth: 1,
  //                       );
  //                     },
  //                     // In 0.66.2, no need for checkToShowHorizontalLine property
  //                   ),
  //                   titlesData: FlTitlesData(
  //                     show: true, // Explicitly set show to true in 0.66.2
  //                     leftTitles: AxisTitles(
  //                       axisNameSize: 0, // Add this for 0.66.2
  //                       sideTitles: SideTitles(
  //                         showTitles: true,
  //                         getTitlesWidget: (value, meta) {
  //                           return Padding(
  //                             padding: const EdgeInsets.only(right: 8.0),
  //                             child: Text(
  //                               value.toInt().toString(),
  //                               style: const TextStyle(
  //                                 color: Color(0xFF718096),
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                         reservedSize: 30,
  //                       ),
  //                     ),
  //                     bottomTitles: AxisTitles(
  //                       axisNameSize: 0, // Add this for 0.66.2
  //                       sideTitles: SideTitles(
  //                         showTitles: true,
  //                         getTitlesWidget: (value, meta) {
  //                           final index = value.toInt();
  //                           if (index >= 0 && index < dashboardData.penjualanHarian.length) {
  //                             final data = dashboardData.penjualanHarian[index];
  //                             return Padding(
  //                               padding: const EdgeInsets.only(top: 8.0),
  //                               child: Text(
  //                                 DateFormat('dd/MM').format(data.date),
  //                                 style: const TextStyle(
  //                                   color: Color(0xFF718096),
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             );
  //                           }
  //                           return const SizedBox();
  //                         },
  //                         reservedSize: 30,
  //                       ),
  //                     ),
  //                     rightTitles: const AxisTitles(
  //                       axisNameSize: 0, // Add this for 0.66.2
  //                       sideTitles: SideTitles(showTitles: false),
  //                     ),
  //                     topTitles: const AxisTitles(
  //                       axisNameSize: 0, // Add this for 0.66.2
  //                       sideTitles: SideTitles(showTitles: false),
  //                     ),
  //                   ),
  //                   borderData: FlBorderData(show: false),
  //                   minX: 0,
  //                   maxX: dashboardData.penjualanHarian.length.toDouble() - 1,
  //                   minY: 0,
  //                   maxY: 30,
  //                   lineBarsData: [
  //                     LineChartBarData(
  //                       spots: List.generate(dashboardData.penjualanHarian.length, (index) {
  //                         return FlSpot(
  //                           index.toDouble(),
  //                           dashboardData.penjualanHarian[index].value,
  //                         );
  //                       }),
  //                       isCurved: true,
  //                       gradient: LinearGradient(
  //                         colors: gradientColors,
  //                       ),
  //                       barWidth: 3,
  //                       isStrokeCapRound: true,
  //                       dotData: FlDotData(
  //                         show: true,
  //                         getDotPainter: (spot, percent, barData, index) {
  //                           return FlDotCirclePainter(
  //                             radius: 5,
  //                             color: Colors.white,
  //                             strokeWidth: 2,
  //                             strokeColor: gradientColors[0],
  //                           );
  //                         },
  //                       ),
  //                       belowBarData: BarAreaData(
  //                         show: true,
  //                         gradient: LinearGradient(
  //                           colors: [
  //                             gradientColors[0].withOpacity(0.3),
  //                             gradientColors[1].withOpacity(0.0),
  //                           ],
  //                           begin: Alignment.topCenter,
  //                           end: Alignment.bottomCenter,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildEmptyChartState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF718096),
            ),
          ),
        ),
      ),
    );
  }
}

// Data models untuk dashboard
class DashboardData {
  final DateTimeRange dateRange;
  final int totalPenjualan;
  final int distribusiKecamatan;
  final double rataRataPenjualanPerHari;
  final int distribusiKabupaten;
  final int distribusiProvinsi;
  final int totalPendapatan;
  final List<ItemData> itemTerjual;
  final List<PerformaData> performaPenjualan;
  final List<PenjualanHarian> penjualanHarian;

  DashboardData({
    required this.dateRange,
    required this.totalPenjualan,
    required this.distribusiKecamatan,
    required this.rataRataPenjualanPerHari,
    required this.distribusiKabupaten,
    required this.distribusiProvinsi,
    required this.totalPendapatan,
    required this.itemTerjual,
    required this.performaPenjualan,
    required this.penjualanHarian,
  });
}

class ItemData {
  final String name;
  final double value;
  final String label;

  ItemData(this.name, this.value, this.label);
}

class PerformaData {
  final String name;
  final double value;

  PerformaData(this.name, this.value);
}

class PenjualanHarian {
  final DateTime date;
  final double value;

  PenjualanHarian(this.date, this.value);
}