#pragma once

#include <QObject>
#include <cmath>
#include <type_traits>

namespace QHUD {

// ── BaseViewModel ─────────────────────────────────────────────────
// Shared utility base class for all ViewModels.
// Provides trySetProperty() — emits the NOTIFY signal ONLY if the
// value actually changed, avoiding spurious QML rebinds.
//
// Usage in derived class:
//   trySetProperty(m_speed, newVal, &MyVM::speedChanged);
class BaseViewModel : public QObject {
    Q_OBJECT

protected:
    explicit BaseViewModel(QObject* parent = nullptr) : QObject(parent) {}

    // Generic: works for integers, bools, QStrings (uses operator !=)
    // Floating-point: uses epsilon comparison (1e-9)
    template<typename T, typename Derived, typename Signal>
    void trySetProperty(T& member, const T& newValue, Signal (Derived::*signal)()) {
        bool changed = false;

        if constexpr (std::is_floating_point_v<T>) {
            if (std::abs(member - newValue) > 1e-9) {
                member = newValue;
                changed = true;
            }
        } else {
            if (member != newValue) {
                member = newValue;
                changed = true;
            }
        }

        if (changed) {
            Q_EMIT (static_cast<Derived*>(this)->*signal)();
        }
    }
};

} // namespace QHUD
