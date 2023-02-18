/**
  ******************************************************************************
  * File Name          : brewinggraph.cpp
  * Description        : Brewery Bar Graph widget class
  ******************************************************************************
  * @attention
**/

#include "brewinggraph.h"
#include <QPainter>

#include <QDebug>

BrewingGraph::BrewingGraph(QQuickItem *parent) : QQuickPaintedItem(parent),
      m_barColor(QColor(80,80,80)),
      m_value(65.4),
      m_graphMin(0),
      m_graphMax(100)
{
}

qreal BrewingGraph::mapValues(qreal value, qreal outputMax) {
    return  (value - this->m_graphMin) * (outputMax - this->m_graphMin) / (this->m_graphMax - this->m_graphMin) + this->m_graphMin;
}


void BrewingGraph::paint(QPainter *painter) {

    painter->setRenderHint(QPainter::Antialiasing);

    qreal barWidth = boundingRect().width();
    qreal barHeight = boundingRect().height();
    qreal valueLine = mapValues(this->m_value, barWidth);

    // Draw Outer Frame
    painter->save();
    painter->drawRect(boundingRect());
    painter->restore();

    // Draw Fill Bar
    painter->save();
    QBrush brush(QColor("#50007430"));
    painter->setBrush(brush);
    painter->setPen(Qt::NoPen);
    painter->drawRect(QRect(0, 0, valueLine, barHeight));
    painter->restore();

    // Draw Value Line
    painter->save();
    painter->setPen(QPen(QColor("black")));
    painter->drawLine(valueLine, 0, valueLine, barHeight);
    painter->restore();


    // Set Fonts for Text
    QFont textFont;
    textFont.setFamily("Helvetica");
    textFont.setPixelSize(12);
    QFontMetrics fm(textFont);

    // Draw Value Text
    painter->save();
    painter->setPen(QPen(QColor("black")));
    painter->setFont(textFont);
    int textSpacer = fm.horizontalAdvance(QString::number(m_value)) + 1;
    painter->drawText(QRect(valueLine + 5, 0, valueLine + textSpacer, barHeight), Qt::AlignBottom, QString::number(m_value));
    painter->restore();
}

void BrewingGraph::setBarColor(QColor value) {
    if (m_barColor == value)
        return;
    m_barColor = value;
    emit barColorChanged();
}

void BrewingGraph::setValue (qreal value) {
    if (m_value == value)
        return;
    m_value = value;
    emit valueChanged();
}

void BrewingGraph::setGraphMin(qreal value) {
    if (m_graphMin == value)
        return;
    m_graphMin = value;
    emit graphMinChanged();
}

void BrewingGraph::setGraphMax(qreal value) {
    if (m_graphMax == value)
        return;
    m_graphMax = value;
    emit graphMaxChanged();
}
