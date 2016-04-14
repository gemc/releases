/// \file detector_editor.h
/// Defines the detector_editor class.\n
/// detector_editor is a QDialog formed by
/// Placement, Dimensions, Sensitivity, Magnetic Field Tabs
/// \author \n Maurizio Ungaro
/// \author mail: ungaro@jlab.org\n\n\n

#ifndef DETECTOR_EDITOR_H
#define DETECTOR_EDITOR_H


// %%%%%%%%%%
// Qt headers
// %%%%%%%%%%
#include <QDialog>
#include <QDialogButtonBox>
#include <QLabel>
#include <QLineEdit>
#include <QTabWidget>

// %%%%%%%%%%%%%
// gemc headers
// %%%%%%%%%%%%%
#include "detector.h"
#include "detector_editor.h"


/// \class PlacementTab
/// <b> PlacementTab </b>\n\n
/// This is the tab inside DetectorEditor
/// used to move/rotate the volume.
class PlacementTab : public QWidget
{
	Q_OBJECT
	
	public:
		
		PlacementTab(detector*, QWidget *parent = 0);  ///< Constructor
		
		detector *Detector;         ///< pointer to detector
		
		QLabel*    placeXLabel;     ///< label for x position
		QLabel*    placeYLabel;     ///< label for y position
		QLabel*    placeZLabel;     ///< label for z position
		QLineEdit* placeXEdit;      ///< line editor for x position
		QLineEdit* placeYEdit;      ///< line editor for y position
		QLineEdit* placeZEdit;      ///< line editor for z position
		
		QLabel*    rotXLabel;     ///< label for x rotation
		QLabel*    rotYLabel;     ///< label for y rotation
		QLabel*    rotZLabel;     ///< label for z rotation
		QLineEdit* rotXEdit;      ///< line editor for x rotation
		QLineEdit* rotYEdit;      ///< line editor for y rotation
		QLineEdit* rotZEdit;      ///< line editor for z rotation
		
	private slots:
		void change_dname(QString); ///< changes detector.name
		void change_placement();    ///< changes coordinates/rotation of the detector
		
};


/// \class SensitivityTab
/// <b> SensitivityTab </b>\n\n
/// Infos about:
/// material
/// sensitive volume (matches bank name)
/// hit process routine
/// production cut
/// time window
/// max step
class SensitivityTab : public QWidget
{
	Q_OBJECT
	
	public:
		
		SensitivityTab(detector*, QWidget *parent = 0);  ///< Constructor
		
		detector *Detector;         ///< pointer to detector
		
};

/// \class DimensionsTab
/// <b> DimensionsTab </b>\n\n
/// This is the tab inside DetectorEditor
/// used to change the volume dimensions.
/// It automatically recognize the solid type
/// and generates as many dimension editors
/// as required.
class DimensionsTab : public QWidget
{
	Q_OBJECT
	
	public:
		DimensionsTab(detector*, QWidget *parent = 0);  ///< Constructor
		detector *Detector;                   ///< Pointer to detector object
		vector<QLabel*> dimTypesLabel;        ///< vector of label for dimension. Size depends on solid type
		vector<QLineEdit*> dimTypesEdit;      ///< vector of line editor for dimension. Size depends on solid type
		
	private slots:
		void change_dimension();              ///< changes the detector dimensions
};

/// \class DetectorEditor
/// <b> DetectorEditor </b>\n\n
/// detector_editor is derived from QDialog
/// and formed by Placement, Dimensions,
/// Sensitivity, Magnetic Field Tabs
class DetectorEditor : public QDialog
{
	Q_OBJECT
	
	public:
		DetectorEditor(detector*, QWidget *parent = 0);  ///< Constructor
		detector *Detector;                              ///< Pointer to detector object
		
	private:
		QTabWidget *tabWidget;                           ///< Contains Placement, Dimensions, Sensitivity, Magnetic Field Tabs
		QDialogButtonBox *buttonBox;                     ///< "OK" or "Cancel"
};

#endif
