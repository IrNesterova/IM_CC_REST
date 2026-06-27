package portfolio.example.im_cc.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import portfolio.example.im_cc.models.SubtleMutationTableEntry;

import java.util.List;

@Repository
public interface SubtleMutationTableRepository extends JpaRepository<SubtleMutationTableEntry, Long> {
    List<SubtleMutationTableEntry> findAllByOrderByD100MinAsc();
}