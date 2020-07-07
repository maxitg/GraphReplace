#include "Expression.hpp"

#include <algorithm>
#include <memory>
#include <unordered_map>
#include <unordered_set>
#include <utility>
#include <vector>

namespace SetReplace {
class AtomsIndex::Implementation {
 private:
  const GetAtomsVectorFunc getAtomsVector_;
  std::unordered_map<Atom, std::unordered_set<ExpressionID>> index_;

 public:
  explicit Implementation(GetAtomsVectorFunc getAtomsVector) : getAtomsVector_(std::move(getAtomsVector)) {}

  void removeExpressions(const std::vector<ExpressionID>& expressionIDs) {
    const std::unordered_set<ExpressionID> expressionsToDelete(expressionIDs.begin(), expressionIDs.end());

    std::unordered_set<Atom> involvedAtoms;
    for (const auto& expression : expressionIDs) {
      const auto& atomsVector = getAtomsVector_(expression);
      involvedAtoms.insert(atomsVector.begin(), atomsVector.end());
    }

    for (const auto& atom : involvedAtoms) {
      auto& atomExpressionSet = index_[atom];
      auto atomExpressionIterator = atomExpressionSet.begin();
      const auto atomExpressionSetEnd = atomExpressionSet.cend();
      while (atomExpressionIterator != atomExpressionSetEnd) {
        if (expressionsToDelete.count(*atomExpressionIterator)) {
          atomExpressionIterator = atomExpressionSet.erase(atomExpressionIterator);
        } else {
          ++atomExpressionIterator;
        }
      }
      if (atomExpressionSet.empty()) {
        index_.erase(atom);
      }
    }
  }

  void addExpressions(const std::vector<ExpressionID>& expressionIDs) {
    for (const auto& expressionID : expressionIDs) {
      for (const auto& atom : getAtomsVector_(expressionID)) {
        index_[atom].insert(expressionID);
      }
    }
  }

  std::unordered_set<ExpressionID> expressionsContainingAtom(const Atom atom) const {
    const auto resultIterator = index_.find(atom);
    return resultIterator != index_.end() ? resultIterator->second : std::unordered_set<ExpressionID>();
  }
};

AtomsIndex::AtomsIndex(const GetAtomsVectorFunc& getAtomsVector)
    : implementation_(std::make_shared<Implementation>(getAtomsVector)) {}

void AtomsIndex::removeExpressions(const std::vector<ExpressionID>& expressionIDs) {
  implementation_->removeExpressions(expressionIDs);
}

void AtomsIndex::addExpressions(const std::vector<ExpressionID>& expressionIDs) {
  implementation_->addExpressions(expressionIDs);
}

std::unordered_set<ExpressionID> AtomsIndex::expressionsContainingAtom(const Atom atom) const {
  return implementation_->expressionsContainingAtom(atom);
}
}  // namespace SetReplace
