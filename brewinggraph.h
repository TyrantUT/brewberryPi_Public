#ifndef BREWINGGRAPH_H
#define BREWINGGRAPH_H

#include <QQuickPaintedItem>

class BrewingGraph : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor barColor READ getBarColor WRITE setBarColor NOTIFY barColorChanged)
    Q_PROPERTY(qreal value READ getValue WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(qreal graphMin READ getGraphMin WRITE setGraphMin NOTIFY graphMinChanged)
    Q_PROPERTY(qreal graphMax READ getGraphMax WRITE setGraphMax NOTIFY graphMaxChanged)

public:
    BrewingGraph(QQuickItem *parent = 0);
    qreal mapValues(qreal value, qreal outputMax);
    void paint(QPainter *painter) override;

    QColor getBarColor() {return m_barColor;}
    qreal getValue() {return m_value;}  
    qreal getGraphMin() {return m_graphMin;}
    qreal getGraphMax() {return m_graphMax;}

    void setBarColor(QColor value);
    void setValue (qreal value); 
    void setGraphMin(qreal value);
    void setGraphMax(qreal value);

signals:
    void barColorChanged();
    void valueChanged();  
    void graphMinChanged();
    void graphMaxChanged();

private:
    QColor m_barColor;
    qreal m_value;
    qreal m_graphMin;
    qreal m_graphMax;
};

#endif // BREWINGGRAPH_H
