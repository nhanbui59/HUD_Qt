#include "config/AppConfig.h"

namespace QHUD {
namespace AppConfig {

const std::vector<std::pair<double, double>> ROUTE_COORDINATES = {
    {106.701342, 10.776711}, {106.70127,  10.776629},
    {106.70122,  10.776571}, {106.701122, 10.776458},
    {106.700979, 10.776294}, {106.701019, 10.776258},
    {106.701103, 10.776181}, {106.701158, 10.776131},
    {106.701257, 10.77604},  {106.701329, 10.775974},
    {106.701744, 10.775595}, {106.701776, 10.775566},
    {106.701872, 10.775475}, {106.701941, 10.775415},
    {106.702115, 10.775263}, {106.70217,  10.775218},
    {106.702368, 10.775034}, {106.702722, 10.774705},
    {106.703282, 10.774197}, {106.703332, 10.774151},
    {106.703671, 10.773838}, {106.703717, 10.773795},
    {106.704543, 10.773031}, {106.704819, 10.772775},
    {106.705399, 10.772228}, {106.704962, 10.771763},
    {106.704795, 10.771578}, {106.704875, 10.771575},
    {106.705199, 10.771564}
};

const QString STREET_LE_THANH_TON      = QStringLiteral("Le Thanh Ton");
const QString STREET_NGUYEN_HUE         = QStringLiteral("Nguyen Hue");
const QString STREET_TON_DUC_THANG      = QStringLiteral("Ton Duc Thang");
const QString STREET_HAI_TRIEU          = QStringLiteral("Hai Trieu");
const QString STREET_HAI_TRIEU_BITEXCO  = QStringLiteral("Hai Trieu (Bitexco)");
const QString STREET_DESTINATION        = QStringLiteral("Dich den");
const QString STREET_BITEXCO_TOWER      = QStringLiteral("Bitexco Tower");
const QString INITIAL_NEXT_TURN_STREET  = QStringLiteral("Nguyen Hue");
const QString INITIAL_ETA               = QStringLiteral("03:45 min");

} // namespace AppConfig
} // namespace QHUD
