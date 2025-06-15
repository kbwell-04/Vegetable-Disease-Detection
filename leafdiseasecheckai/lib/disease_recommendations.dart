    import 'package:flutter/material.dart';

    // Define DiseaseInfo class separately
    class DiseaseInfo {
      final String displayName;
      final List<String> treatments;
      final List<String> prevention;

      const DiseaseInfo({
        required this.displayName,
        required this.treatments,
        required this.prevention,
      });
    }

    class DiseaseRecommendations {
      // Complete disease database - matches EXACTLY with labels.txt
      static final Map<String, DiseaseInfo> _diseases = {
        'Pepper__bell___Bacterial_spot': DiseaseInfo(
          displayName: 'Pepper Bacterial Spot',
          treatments: [
            'Remove infected plants immediately',
            'Apply copper-based bactericide weekly',
            'Avoid working with wet plants',
            'Rotate crops for 2-3 years',
            'Use disease-free seeds'
          ],
          prevention: [
            'Plant resistant varieties (e.g., Aristotle)',
            'Provide adequate spacing (18-24 inches)',
            'Water early in the day',
            'Sanitize tools regularly'
          ],
        ),
        'Pepper__bell___healthy': DiseaseInfo(
          displayName: 'Healthy Pepper',
          treatments: [
            'Continue proper care routines',
            'Inspect plants weekly',
            'Maintain consistent moisture',
            'Apply balanced nutrients'
          ],
          prevention: [
            'Rotate crops every 2-3 years',
            'Remove plant debris',
            'Sterilize gardening tools',
            'Monitor for early signs of disease'
          ],
        ),
        'Potato___Early_blight': DiseaseInfo(
          displayName: 'Potato Early Blight',
          treatments: [
            'Apply chlorothalonil fungicide weekly',
            'Remove infected leaves',
            'Apply straw mulch',
            'Use balanced fertilizer'
          ],
          prevention: [
            'Practice 3-year crop rotation',
            'Destroy crop residues after harvest',
            'Avoid overhead irrigation',
            'Select resistant varieties'
          ],
        ),
        'Potato___Late_blight': DiseaseInfo(
          displayName: 'Potato Late Blight',
          treatments: [
            'Destroy infected plants immediately',
            'Apply fungicides preventatively',
            'Stop overhead watering',
            'Harvest early if outbreak occurs'
          ],
          prevention: [
            'Plant certified disease-free seed potatoes',
            'Monitor weather conditions',
            'Remove volunteer plants',
            'Use resistant varieties'
          ],
        ),
        'Potato___healthy': DiseaseInfo(
          displayName: 'Healthy Potato',
          treatments: [
            'Maintain good cultural practices',
            'Monitor regularly for pests',
            'Water consistently',
            'Fertilize appropriately'
          ],
          prevention: [
            'Practice crop rotation',
            'Use certified seed potatoes',
            'Keep field clean of debris',
            'Control weeds'
          ],
        ),
        'Tomato___Bacterial_spot': DiseaseInfo(
          displayName: 'Tomato Bacterial Spot',
          treatments: [
            'Remove infected plants immediately',
            'Apply copper-based bactericide every 7-10 days',
            'Avoid overhead watering',
            'Rotate with non-solanaceous crops for 2-3 years',
            'Use disease-free seeds'
          ],
          prevention: [
            'Plant resistant varieties (e.g., Hawaii 7998)',
            'Space plants 24-36 inches apart',
            'Water at soil level in morning',
            'Disinfect tools with 10% bleach solution'
          ],
        ),
        'Tomato___Early_blight': DiseaseInfo(
          displayName: 'Tomato Early Blight',
          treatments: [
            'Apply chlorothalonil fungicide weekly',
            'Prune infected lower leaves',
            'Apply organic mulch',
            'Use balanced fertilizer (10-10-10)'
          ],
          prevention: [
            'Rotate crops annually',
            'Remove plant debris after harvest',
            'Stake plants for better air flow',
            'Avoid wetting foliage'
          ],
        ),
        'Tomato___Late_blight': DiseaseInfo(
          displayName: 'Tomato Late Blight',
          treatments: [
            'Destroy infected plants (do not compost)',
            'Apply mancozeb fungicide preventatively',
            'Stop all overhead watering',
            'Harvest mature fruit early if outbreak occurs'
          ],
          prevention: [
            'Monitor weather for cool, wet conditions',
            'Plant resistant varieties (Defiant, Mountain Merit)',
            'Remove volunteer tomato/potato plants',
            'Disinfect tools with bleach solution'
          ],
        ),
        'Tomato___Leaf_Mold': DiseaseInfo(
          displayName: 'Tomato Leaf Mold',
          treatments: [
            'Increase ventilation in greenhouses',
            'Apply chlorothalonil fungicide',
            'Remove infected leaves promptly',
            'Reduce humidity below 85%'
          ],
          prevention: [
            'Plant resistant varieties (Legend, Starbuck)',
            'Space plants 3-4 feet apart',
            'Water plants early in the day',
            'Sterilize greenhouse between seasons'
          ],
        ),
        'Tomato___Septoria_leaf_spot': DiseaseInfo(
          displayName: 'Tomato Septoria Leaf Spot',
          treatments: [
            'Spray copper fungicide every 7-10 days',
            'Remove infected leaves immediately',
            'Apply 3-4 inches of organic mulch',
            'Rotate crops for 2 years'
          ],
          prevention: [
            'Use disease-free certified seeds',
            'Avoid overhead irrigation',
            'Disinfect tools between plants',
            'Remove nightshade weeds'
          ],
        ),
        'Tomato___Spider_mites Two-spotted_spider_mite': DiseaseInfo(
          displayName: 'Tomato Spider Mites (Two-spotted)',
          treatments: [
            'Spray plants with strong water jet',
            'Apply insecticidal soap every 5-7 days',
            'Release predatory mites (P. persimilis)',
            'Prune heavily infested leaves'
          ],
          prevention: [
            'Monitor leaf undersides weekly',
            'Maintain 60-70% humidity',
            'Avoid excessive nitrogen fertilizer',
            'Remove dust from leaves regularly'
          ],
        ),
        'Tomato___Target_Spot': DiseaseInfo(
          displayName: 'Tomato Target Spot',
          treatments: [
            'Apply azoxystrobin fungicide',
            'Remove infected leaves at first sign',
            'Improve air circulation',
            'Rotate crops for 2-3 years'
          ],
          prevention: [
            'Plant less susceptible varieties',
            'Water at base of plants',
            'Ensure full sunlight exposure',
            'Remove all plant debris after harvest'
          ],
        ),
        'Tomato___Tomato_Yellow_Leaf_Curl_Virus': DiseaseInfo(
          displayName: 'Tomato Yellow Leaf Curl Virus',
          treatments: [
            'Remove and destroy infected plants',
            'Control whiteflies with pyrethrins',
            'Plant resistant varieties (Tygress, Tyler)',
            'Use reflective mulch'
          ],
          prevention: [
            'Use virus-free certified transplants',
            'Install floating row covers',
            'Remove nightshade weed hosts',
            'Monitor for whiteflies weekly'
          ],
        ),
        'Tomato___Tomato_mosaic_virus': DiseaseInfo(
          displayName: 'Tomato Mosaic Virus',
          treatments: [
            'Destroy infected plants immediately',
            'Disinfect tools with 20% milk solution',
            'Prohibit smoking near plants',
            'Plant resistant varieties (Sophya, Plum Regal)'
          ],
          prevention: [
            'Use certified virus-free seeds',
            'Control aphid populations',
            'Remove weed hosts regularly',
            'Wash hands before handling plants'
          ],
        ),
        'Tomato___healthy': DiseaseInfo(
          displayName: 'Healthy Tomato',
          treatments: [
            'Continue current good practices',
            'Monitor plants weekly',
            'Maintain 1-2 inches water weekly',
            'Apply balanced fertilizer monthly'
          ],
          prevention: [
            'Practice 3-year crop rotation',
            'Keep garden free of debris',
            'Sterilize tools between uses',
            'Encourage beneficial insects'
          ],
        ),
      };
      /// Shows recommendation dialog for detected disease
      static Widget getRecommendationCard(String diseaseKey, BuildContext context) {
        // Clean the input key
        debugPrint('Raw diseaseKey from model: "$diseaseKey"');
        final cleanKey = diseaseKey.trim().replaceAll('"', '');
        debugPrint('Cleaned diseaseKey: "$cleanKey"');

        // Get the matching disease or fallback to healthy
        final disease = _diseases[cleanKey] ?? _diseases['Tomato__healthy']!;
        debugPrint('Showing recommendations for: ${disease.displayName}');

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '${disease.displayName} Management',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTreatmentSection('Recommended Treatments', disease.treatments),
                  const SizedBox(height: 16),
                  _buildTreatmentSection('Prevention Tips', disease.prevention),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      /// Builds a treatment/prevention section with bullet points
      static Widget _buildTreatmentSection(String title, List<String> items) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        );
      }

      /// Builds a section with title and bullet points
      static Widget _buildSection(String title, List<String> items) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        );
      }

      /// Converts model output to display-friendly name
      static String getCleanDiseaseName(String diseaseKey) {
        // Special handling for spider mites
        if (diseaseKey == 'Tomato___Spider_mites Two-spotted_spider_mite') {
          return 'Tomato Spider Mites';
        }

        // Handle other cases
        return diseaseKey
            .replaceAll('_', ' ');
      }
    }