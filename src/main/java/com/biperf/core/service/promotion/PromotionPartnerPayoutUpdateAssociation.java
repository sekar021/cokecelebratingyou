/*
 * (c) 2008 BI, Inc.  All rights reserved.
 * $Source: /usr/local/ndscvsroot/products/penta-g/src/java/com/biperf/core/service/promotion/PromotionPartnerPayoutUpdateAssociation.java,v $
 */

package com.biperf.core.service.promotion;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import com.biperf.core.dao.claim.ClaimFormDAO;
import com.biperf.core.dao.hierarchy.NodeTypeDAO;
import com.biperf.core.dao.product.ProductCategoryDAO;
import com.biperf.core.dao.product.ProductDAO;
import com.biperf.core.dao.promotion.PromotionPayoutDAO;
import com.biperf.core.domain.BaseDomain;
import com.biperf.core.domain.enums.PromotionPayoutType;
import com.biperf.core.domain.enums.PromotionStatusType;
import com.biperf.core.domain.enums.StackRankFactorType;
import com.biperf.core.domain.hierarchy.NodeType;
import com.biperf.core.domain.product.Product;
import com.biperf.core.domain.product.ProductCategory;
import com.biperf.core.domain.promotion.GoalLevel;
import com.biperf.core.domain.promotion.GoalQuestPromotion;
import com.biperf.core.domain.promotion.ProductClaimPromotion;
import com.biperf.core.domain.promotion.Promotion;
import com.biperf.core.domain.promotion.PromotionPayout;
import com.biperf.core.domain.promotion.PromotionPayoutGroup;
import com.biperf.core.domain.promotion.StackRankPayout;
import com.biperf.core.domain.promotion.StackRankPayoutGroup;
import com.biperf.core.exception.ServiceErrorExceptionWithRollback;
import com.biperf.core.service.UpdateAssociationRequest;
import com.biperf.core.service.util.ServiceError;
import com.biperf.core.service.util.ServiceErrorMessageKeys;
import com.biperf.core.utils.BeanLocator;
import com.biperf.core.utils.HibernateSessionManager;

/**
 * PromotionPartnerPayoutUpdateAssociation.
 * <p>
 * <b>Change History:</b><br>
 * <table border="1">
 * <tr>
 * <th>Author</th>
 * <th>Date</th>
 * <th>Version</th>
 * <th>Comments</th>
 * </tr>
 * <tr>
 * <td>reddy</td>
 * <td>Feb 26, 2008</td>
 * <td>1.0</td>
 * <td>created</td>
 * </tr>
 * </table>
 * 
 */
public class PromotionPartnerPayoutUpdateAssociation extends UpdateAssociationRequest
{
  // ---------------------------------------------------------------------------
  // Public Methods
  // ---------------------------------------------------------------------------

  /**
   * Constructs a <code>PromotionPartnerPayoutUpdateAssociation</code> object.
   * 
   * @param detachedPromotion a detached {@link Promotion} object.
   */
  public PromotionPartnerPayoutUpdateAssociation( Promotion detachedPromotion )
  {
    super( detachedPromotion );
  }

  /**
   * Use the detached {@link Promotion} object to update the attached {@link Promotion} object.
   * 
   * @param attachedDomain the attached version of the {@link Promotion} object.
   */
  public void execute( BaseDomain attachedDomain )
  {
    Promotion attachedPromotion = (Promotion)attachedDomain;

    if ( attachedPromotion.isProductClaimPromotion() )
    {
      updateProductClaimPromotion( (ProductClaimPromotion)attachedPromotion );
    }
    if ( attachedPromotion.isGoalQuestPromotion() )
    {
      updateGoalQuestPromotion( (GoalQuestPromotion)attachedPromotion );
    }
  }

  /**
   * Uses attached and detached versions of a {@link Promotion} object to perform additional
   * validation on the object. When the application removes promotion payouts from a parent
   * promotion, it also removes qualifying promotion payouts from the parent promotion's child
   * promotions. If doing this causes one of a child promotion's promotion payout groups to become
   * empty, then the application aborts the action and reports an error. The following code ensures
   * that every promotion payout group of every child promotion contains at least one promotion
   * payout, and that every promotion payout for a child promotion references a product or product
   * category that is referenced by a promotion payout for the parent promotion.
   * 
   * @param attachedDomain the attached version of the {@link Promotion} object.
   * @throws com.biperf.core.exception.ServiceErrorExceptionWithRollback if a validation error
   *           occurs.
   */
  public void validate( BaseDomain attachedDomain ) throws ServiceErrorExceptionWithRollback
  {
    List validationErrors = new ArrayList();

    // Currently, only product claim promotions can have child promotions.
    Object detachedDomain = getDetachedDomain();
    if ( attachedDomain instanceof ProductClaimPromotion && detachedDomain instanceof ProductClaimPromotion )
    {
      ProductClaimPromotion attachedPromotion = (ProductClaimPromotion)attachedDomain;
      ProductClaimPromotion detachedPromotion = (ProductClaimPromotion)detachedDomain;

      if ( attachedPromotion.getChildrenCount() > 0 ) // This is a parent promotion with children.
      {
        List payoutGroupsFromAttachedPromotion = attachedPromotion.getPromotionPayoutGroups();
        List payoutGroupsFromDetachedPromotion = detachedPromotion.getPromotionPayoutGroups();

        Set productsToRemove = getProductsToRemove( getProducts( payoutGroupsFromAttachedPromotion ), getProducts( payoutGroupsFromDetachedPromotion ) );
        Set productCategoriesToRemove = getProductCategoriesToRemove( getProductCategories( payoutGroupsFromAttachedPromotion ), getProductCategories( payoutGroupsFromDetachedPromotion ) );

        if ( productsToRemove.size() > 0 || productCategoriesToRemove.size() > 0 )
        {
          for ( Iterator iter = attachedPromotion.getChildPromotions().iterator(); iter.hasNext(); )
          {
            ProductClaimPromotion childPromotion = (ProductClaimPromotion)iter.next();
            for ( Iterator payoutGroupIter = childPromotion.getPromotionPayoutGroups().iterator(); payoutGroupIter.hasNext(); )
            {
              PromotionPayoutGroup payoutGroup = (PromotionPayoutGroup)payoutGroupIter.next();

              List payouts = new ArrayList();
              payouts.addAll( payoutGroup.getPromotionPayouts() );

              for ( Iterator payoutIter = payouts.iterator(); payoutIter.hasNext(); )
              {
                PromotionPayout payout = (PromotionPayout)payoutIter.next();

                Product product = payout.getProduct();
                if ( product != null )
                {
                  if ( productsToRemove.contains( product ) )
                  {
                    payoutIter.remove();
                  }
                }
                else
                {
                  ProductCategory productCategory = payout.getProductCategory();
                  if ( productCategory != null )
                  {
                    if ( productCategoriesToRemove.contains( productCategory ) )
                    {
                      payoutIter.remove();
                    }
                  }
                }
              }

              if ( payouts.isEmpty() )
              {
                validationErrors.add( new ServiceError( ServiceErrorMessageKeys.PROMOTION_EMPTY_PROMOTION_PAYOUT_GROUP, payoutGroup.getPromotion().getName() ) );
              }
            }
          }
        }
      }

      if ( !validationErrors.isEmpty() )
      {
        throw new ServiceErrorExceptionWithRollback( validationErrors );
      }
    }
  }

  // ---------------------------------------------------------------------------
  // Private Methods
  // ---------------------------------------------------------------------------

  private void checkParentPayoutGroup( PromotionPayoutGroup detachedPromotionPayoutGroup )
  {
    // if this contains a parentPromotionPayoutGroup then lookup the group
    if ( detachedPromotionPayoutGroup.getParentPromotionPayoutGroup() != null )
    {
      PromotionPayoutDAO promotionPayoutDAO = getPromotionPayoutDAO();
      detachedPromotionPayoutGroup.setParentPromotionPayoutGroup( promotionPayoutDAO.getGroupById( detachedPromotionPayoutGroup.getParentPromotionPayoutGroup().getId() ) );
    }
  }

  /**
   * Check ProductCategory objects for IDs. If and Id exists, lookup the ProductCategory and get the
   * version so an insert is not performed.
   * 
   * @param promotionPayoutGroup
   */
  private void checkNodeTypes( StackRankPayoutGroup promotionPayoutGroup )
  {
    if ( promotionPayoutGroup.getNodeType() != null )
    {
      NodeType nodeType = promotionPayoutGroup.getNodeType();
      if ( nodeType != null && nodeType.getId() != null )
      {
        NodeTypeDAO nodeTypeDAO = getNodeTypeDAO();
        promotionPayoutGroup.setNodeType( nodeTypeDAO.getNodeTypeById( nodeType.getId() ) );
      }
    }

  }

  /**
   * Check ProductCategory objects for IDs. If and Id exists, lookup the ProductCategory and get the
   * version so an insert is not performed.
   * 
   * @param promotionPayoutGroup
   */
  private void checkProductCategories( PromotionPayoutGroup promotionPayoutGroup )
  {
    if ( promotionPayoutGroup.getPromotionPayouts() != null )
    {
      Iterator promotionPayoutsIter = promotionPayoutGroup.getPromotionPayouts().iterator();
      while ( promotionPayoutsIter.hasNext() )
      {
        PromotionPayout payout = (PromotionPayout)promotionPayoutsIter.next();
        ProductCategory productCategory = payout.getProductCategory();

        // If the productCategory has an id, lookup the version so an insert is not performed
        if ( productCategory != null && productCategory.getId() != null )
        {
          Long categoryId = productCategory.getId();

          // check if there is subcategory and use that instead to do the product category lookup
          if ( productCategory.getSubcategories() != null && productCategory.getSubcategories().size() == 1 )
          {
            ProductCategory subCategory = (ProductCategory)productCategory.getSubcategories().iterator().next();
            if ( subCategory != null && subCategory.getId() != null )
            {
              categoryId = subCategory.getId();
            }
          }

          ProductCategoryDAO productCategoryDAO = getProductCategoryDAO();
          payout.setProductCategory( productCategoryDAO.getProductCategoryById( categoryId ) );
        }

        // If the product has an id, lookup the version so an insert is not performed
        Product product = payout.getProduct();
        if ( product != null && product.getId() != null )
        {
          ProductDAO productDAO = getProductDAO();
          payout.setProduct( productDAO.getProductById( product.getId() ) );
        }
      } // end while( promotionPayoutsIter.hasNext() )
    } // end if ( promotionPayoutGroup.getPromotionPayouts() != null )

  }

  /**
   * Returns the set of products referenced by the promotion payouts in the given promotion payout
   * groups.
   * 
   * @param payoutGroups a list of promotion payout groups, as a <code>List</code> of
   *          {@link PromotionPayoutGroup} objects.
   * @return the set of products referenced by the promotion payouts in the given promotion payout
   *         groups, as a <code>Set</code> of {@link Product} objects.
   */
  private Set getProducts( List payoutGroups )
  {
    Set products = new HashSet();

    for ( Iterator payoutGroupIter = payoutGroups.iterator(); payoutGroupIter.hasNext(); )
    {
      PromotionPayoutGroup payoutGroup = (PromotionPayoutGroup)payoutGroupIter.next();
      for ( Iterator payoutIter = payoutGroup.getPromotionPayouts().iterator(); payoutIter.hasNext(); )
      {
        PromotionPayout payout = (PromotionPayout)payoutIter.next();

        Product product = payout.getProduct();
        if ( product != null )
        {
          products.add( product );
        }
      }
    }

    return products;
  }

  /**
   * Returns the set of product categories referenced by the promotion payouts in the given
   * promotion payout groups.
   * 
   * @param payoutGroups a list of promotion payout groups, as a <code>List</code> of
   *          {@link PromotionPayoutGroup} objects.
   * @return the set of product categories referenced by the promotion payouts in the given
   *         promotion payout groups, as a <code>Set</code> of {@link ProductCategory} objects.
   */
  private Set getProductCategories( List payoutGroups )
  {
    Set productCategories = new HashSet();

    for ( Iterator payoutGroupIter = payoutGroups.iterator(); payoutGroupIter.hasNext(); )
    {
      PromotionPayoutGroup payoutGroup = (PromotionPayoutGroup)payoutGroupIter.next();
      for ( Iterator payoutIter = payoutGroup.getPromotionPayouts().iterator(); payoutIter.hasNext(); )
      {
        PromotionPayout payout = (PromotionPayout)payoutIter.next();

        ProductCategory productCategory = payout.getProductCategory();
        if ( productCategory != null )
        {
          productCategories.add( productCategory );
        }
      }
    }

    return productCategories;
  }

  /**
   * Returns the products that are no longer referenced by promotion payouts for the target
   * promotion.
   * 
   * @param productsFromAttachedPromotion the products that are referenced by promotion payouts from
   *          the attached version of the {@link Promotion} object, as a <code>Set</code> of
   *          {@link Product} objects. Note: All fields of these {@link Product} objects are either
   *          loaded or loadable.
   * @param productsFromDetachedPromotion the products that are referenced by promotion payouts from
   *          the detached version of the {@link Promotion} object, as a <code>Set</code> of
   *          {@link Product} objects. Note: Only the fields "id" and "name" of these
   *          {@link Product} objects are loaded.
   * @return the products that are no longer referenced by promotion payouts for the target
   *         promotion, as a <code>Set</code> of {@link Product} objects.
   */
  private Set getProductsToRemove( Set productsFromAttachedPromotion, Set productsFromDetachedPromotion )
  {
    Set productsToRemove = new HashSet();

    for ( Iterator iter1 = productsFromAttachedPromotion.iterator(); iter1.hasNext(); )
    {
      Product productFromAttachedPromotion = (Product)iter1.next();
      boolean isFound = false;

      for ( Iterator iter2 = productsFromDetachedPromotion.iterator(); iter2.hasNext(); )
      {
        Product productFromDetachedPromotion = (Product)iter2.next();

        if ( productFromAttachedPromotion.getId().equals( productFromDetachedPromotion.getId() ) )
        {
          isFound = true;
          break;
        }
      }

      if ( !isFound )
      {
        productsToRemove.add( productFromAttachedPromotion );
      }
    }

    return productsToRemove;
  }

  /**
   * Returns the product categories that are no longer referenced by promotion payouts for the
   * target promotion.
   * 
   * @param productCategoriesFromAttachedPromotion the product categories that are referenced by
   *          promotion payouts from the attached version of the {@link Promotion} object, as a
   *          <code>Set</code> of {@link ProductCategory} objects. Note: All fields of these
   *          {@link ProductCategory} objects are either loaded or loadable.
   * @param productCategoriesFromDetachedPromotion the product categories that are referenced by
   *          promotion payouts from the detached version of the {@link Promotion} object, as a
   *          <code>Set</code> of {@link ProductCategory} objects. Note: Only the fields "id" and
   *          "name" of these {@link ProductCategory} objects are loaded.
   * @return the product categories that are no longer referenced by promotion payouts for the
   *         target promotion, as a <code>Set</code> of {@link ProductCategory} objects.
   */
  private Set getProductCategoriesToRemove( Set productCategoriesFromAttachedPromotion, Set productCategoriesFromDetachedPromotion )
  {
    Set productCategoriesToRemove = new HashSet();

    for ( Iterator iter1 = productCategoriesFromAttachedPromotion.iterator(); iter1.hasNext(); )
    {
      ProductCategory productCategoryFromAttachedPromotion = (ProductCategory)iter1.next();
      boolean isFound = false;

      for ( Iterator iter2 = productCategoriesFromDetachedPromotion.iterator(); iter2.hasNext(); )
      {
        ProductCategory productCategoryFromDetachedPromotion = (ProductCategory)iter2.next();

        if ( productCategoryFromAttachedPromotion.getId().equals( productCategoryFromDetachedPromotion.getId() ) )
        {
          isFound = true;
          break;
        }
      }

      if ( !isFound )
      {
        productCategoriesToRemove.add( productCategoryFromAttachedPromotion );
      }
    }

    return productCategoriesToRemove;
  }

  private void updateProductClaimPromotion( ProductClaimPromotion attachedPromotion )
  {
    ProductClaimPromotion detachedPromotion = (ProductClaimPromotion)getDetachedDomain();

    // Remove payouts from child promotions where the product referenced by a payout of a child
    // promotion is not referenced by a payout of the parent promotion.
    removePayoutsFromChildPromotions( attachedPromotion, detachedPromotion );

    attachedPromotion.setPayoutType( detachedPromotion.getPayoutType() );

    if ( PromotionPayoutType.STACK_RANK.equals( attachedPromotion.getPayoutType().getCode() ) )
    {
      this.updateProductClaimPromotionPayout( detachedPromotion, attachedPromotion );
      this.updateProductClaimStackRankPayout( detachedPromotion, attachedPromotion );
    }
    else
    {
      this.updateProductClaimPromotionPayout( detachedPromotion, attachedPromotion );
    }

  }

  /**
   * Removes payouts from child promotions where the product referenced by a payout of a child
   * promotion is not referenced by a payout of the parent promotion.
   * 
   * @param attachedPromotion the attached version of the promotion.
   * @param detachedPromotion the detached version of the promotion.
   */
  private void removePayoutsFromChildPromotions( ProductClaimPromotion attachedPromotion, ProductClaimPromotion detachedPromotion )
  {
    if ( attachedPromotion.getChildrenCount() > 0 ) // This is a parent promotion with children.
    {
      List payoutGroupsFromAttachedPromotion = attachedPromotion.getPromotionPayoutGroups();
      List payoutGroupsFromDetachedPromotion = detachedPromotion.getPromotionPayoutGroups();

      Set productsToRemove = getProductsToRemove( getProducts( payoutGroupsFromAttachedPromotion ), getProducts( payoutGroupsFromDetachedPromotion ) );
      Set productCategoriesToRemove = getProductCategoriesToRemove( getProductCategories( payoutGroupsFromAttachedPromotion ), getProductCategories( payoutGroupsFromDetachedPromotion ) );

      if ( productsToRemove.size() > 0 || productCategoriesToRemove.size() > 0 )
      {
        for ( Iterator iter = attachedPromotion.getChildPromotions().iterator(); iter.hasNext(); )
        {
          ProductClaimPromotion childPromotion = (ProductClaimPromotion)iter.next();
          for ( Iterator payoutGroupIter = childPromotion.getPromotionPayoutGroups().iterator(); payoutGroupIter.hasNext(); )
          {
            PromotionPayoutGroup payoutGroup = (PromotionPayoutGroup)payoutGroupIter.next();
            for ( Iterator payoutIter = payoutGroup.getPromotionPayouts().iterator(); payoutIter.hasNext(); )
            {
              PromotionPayout payout = (PromotionPayout)payoutIter.next();

              Product product = payout.getProduct();
              if ( product != null )
              {
                if ( productsToRemove.contains( product ) )
                {
                  payoutIter.remove();
                }
              }
              else
              {
                ProductCategory productCategory = payout.getProductCategory();
                if ( productCategory != null )
                {
                  if ( productCategoriesToRemove.contains( productCategory ) )
                  {
                    payoutIter.remove();
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  private void updateProductClaimPromotionPayout( ProductClaimPromotion detachedPromotion, ProductClaimPromotion attachedPromotion )
  {
    attachedPromotion.setPayoutManager( detachedPromotion.isPayoutManager() );
    attachedPromotion.setPayoutManagerPercent( detachedPromotion.getPayoutManagerPercent() );
    attachedPromotion.setPayoutManagerPeriod( detachedPromotion.getPayoutManagerPeriod() );
    attachedPromotion.setPayoutCarryOver( detachedPromotion.isPayoutCarryOver() );

    // synch up the promotion payout groups for the promotion
    if ( detachedPromotion.getPromotionPayoutGroups() != null && !detachedPromotion.getPromotionPayoutGroups().isEmpty() )
    {
      Iterator detachedGroupIter = detachedPromotion.getPromotionPayoutGroups().iterator();

      while ( detachedGroupIter.hasNext() )
      {
        PromotionPayoutGroup detachedPromotionPayoutGroup = (PromotionPayoutGroup)detachedGroupIter.next();

        checkProductCategories( detachedPromotionPayoutGroup );

        checkParentPayoutGroup( detachedPromotionPayoutGroup );

        // check if this is a new promotion payout group
        if ( detachedPromotionPayoutGroup.getId() == null || detachedPromotionPayoutGroup.getId().longValue() == 0 )
        {
          attachedPromotion.addPromotionPayoutGroup( detachedPromotionPayoutGroup );
        }
        else
        {
          Iterator attachedGroupIter = attachedPromotion.getPromotionPayoutGroups().iterator();

          while ( attachedGroupIter.hasNext() )
          {
            PromotionPayoutGroup attachedPromotionPayoutGroup = (PromotionPayoutGroup)attachedGroupIter.next();

            if ( detachedPromotionPayoutGroup.getId().equals( attachedPromotionPayoutGroup.getId() ) )
            {
              attachedPromotionPayoutGroup.setSubmitterPayout( detachedPromotionPayoutGroup.getSubmitterPayout() );

              attachedPromotionPayoutGroup.setTeamMemberPayout( detachedPromotionPayoutGroup.getTeamMemberPayout() );

              attachedPromotionPayoutGroup.setQuantity( detachedPromotionPayoutGroup.getQuantity() );
              attachedPromotionPayoutGroup.setMinimumQualifier( detachedPromotionPayoutGroup.getMinimumQualifier() );
              attachedPromotionPayoutGroup.setRetroPayout( detachedPromotionPayoutGroup.getRetroPayout() );

              // synch up the promotion payouts for the group
              if ( detachedPromotionPayoutGroup.getPromotionPayouts() != null && !detachedPromotionPayoutGroup.getPromotionPayouts().isEmpty() )
              {
                Iterator detachedPayoutIter = detachedPromotionPayoutGroup.getPromotionPayouts().iterator();
                while ( detachedPayoutIter.hasNext() )
                {
                  PromotionPayout detachedPayout = (PromotionPayout)detachedPayoutIter.next();

                  // check if this is a new promotion payout
                  if ( detachedPayout.getId() == null || detachedPayout.getId().longValue() == 0 )
                  {
                    attachedPromotionPayoutGroup.addPromotionPayout( detachedPayout );
                  }
                  else
                  {
                    Iterator attachedPayoutIter = attachedPromotionPayoutGroup.getPromotionPayouts().iterator();

                    while ( attachedPayoutIter.hasNext() )
                    {
                      PromotionPayout attachedPayout = (PromotionPayout)attachedPayoutIter.next();
                      if ( detachedPromotionPayoutGroup.getPromotionPayouts().contains( attachedPayout ) )
                      {
                        if ( detachedPayout.getId().equals( attachedPayout.getId() ) )
                        {
                          attachedPayout.setQuantity( detachedPayout.getQuantity() );
                          attachedPayout.setProductOrCategoryStartDate( detachedPayout.getProductOrCategoryStartDate() );
                          attachedPayout.setProductOrCategoryEndDate( detachedPayout.getProductOrCategoryEndDate() );
                        }
                      }
                      else
                      {
                        attachedPayoutIter.remove();
                      }
                    } // end attached payouts iterator
                  }
                } // end detached payouts iterator
              }
            }
          } // end attached payout groups iterator
        }
      } // end detached payout groups iterator
    }
    else
    {
      attachedPromotion.getPromotionPayoutGroups().clear();
    }

    if ( attachedPromotion.getPromotionPayoutGroups() != null && attachedPromotion.getPromotionPayoutGroups().size() > 0 )
    {
      Iterator attachedGroupIterator = attachedPromotion.getPromotionPayoutGroups().iterator();
      while ( attachedGroupIterator.hasNext() )
      {
        if ( !detachedPromotion.getPromotionPayoutGroups().contains( attachedGroupIterator.next() ) )
        {
          attachedGroupIterator.remove();
        }
      }
    }

  }

  /**
   * Updating the stack rank payout groups which are associated with product claim promotion
   * 
   * @param detachedPromotion
   * @param attachedPromotion
   */
  private void updateProductClaimStackRankPayout( ProductClaimPromotion detachedPromotion, ProductClaimPromotion attachedPromotion )
  {
    attachedPromotion.setStackRankFactorType( detachedPromotion.getStackRankFactorType() );
    attachedPromotion.setDisplayStackRankFactor( detachedPromotion.isDisplayStackRankFactor() );
    attachedPromotion.setStackRankApprovalType( detachedPromotion.getStackRankApprovalType() );
    attachedPromotion.setDisplayFullListLinkToParticipants( detachedPromotion.isDisplayFullListLinkToParticipants() );

    if ( !StackRankFactorType.QUANTITY_SOLD.equals( detachedPromotion.getStackRankFactorType().getCode() ) )
    {
      attachedPromotion.setStackRankClaimFormStepElement( getClaimFormDAO().getClaimFormStepElementById( detachedPromotion.getStackRankClaimFormStepElement().getId() ) );
      // getClaimFormStepElementById()
    }

    // synch up the stack rank payout groups for the promotion
    if ( detachedPromotion.getStackRankPayoutGroups() != null && !detachedPromotion.getStackRankPayoutGroups().isEmpty() )
    {
      Iterator detachedGroupIter = detachedPromotion.getStackRankPayoutGroups().iterator();

      while ( detachedGroupIter.hasNext() )
      {
        StackRankPayoutGroup detachedStackRankPayoutGroup = (StackRankPayoutGroup)detachedGroupIter.next();
        checkNodeTypes( detachedStackRankPayoutGroup );
        // check if this is a new stack rank payout group
        if ( detachedStackRankPayoutGroup.getId() == null || detachedStackRankPayoutGroup.getId().longValue() == 0 )
        {
          attachedPromotion.addStackRankPayoutGroup( detachedStackRankPayoutGroup );
        }
        else
        {
          Iterator attachedGroupIter = attachedPromotion.getStackRankPayoutGroups().iterator();

          while ( attachedGroupIter.hasNext() )
          {
            StackRankPayoutGroup attachedStackRankPayoutGroup = (StackRankPayoutGroup)attachedGroupIter.next();

            if ( detachedStackRankPayoutGroup.getId().equals( attachedStackRankPayoutGroup.getId() ) )
            {
              attachedStackRankPayoutGroup.setSubmittersToRankType( detachedStackRankPayoutGroup.getSubmittersToRankType() );
              attachedStackRankPayoutGroup.setNodeType( detachedStackRankPayoutGroup.getNodeType() );
              // If the product has an id, lookup the version so an insert is not performed
              /*
               * NodeType nodeType = detachedStackRankPayoutGroup.getNodeType(); if ( nodeType !=
               * null && nodeType.getId() != null ) { NodeTypeDAO nodeTypeDAO = getNodeTypeDAO();
               * attachedStackRankPayoutGroup.setNodeType( nodeTypeDAO.getNodeTypeById(
               * nodeType.getId() ) ); }
               */
              // synch up the stack rank payouts for the group
              if ( detachedStackRankPayoutGroup.getStackRankPayouts() != null && !detachedStackRankPayoutGroup.getStackRankPayouts().isEmpty() )
              {
                Iterator detachedPayoutIter = detachedStackRankPayoutGroup.getStackRankPayouts().iterator();
                while ( detachedPayoutIter.hasNext() )
                {
                  StackRankPayout detachedPayout = (StackRankPayout)detachedPayoutIter.next();

                  // check if this is a new stack rank payout
                  if ( detachedPayout.getId() == null || detachedPayout.getId().longValue() == 0 )
                  {
                    attachedStackRankPayoutGroup.addStackRankPayout( detachedPayout );
                  }
                  else
                  {
                    Iterator attachedPayoutIter = attachedStackRankPayoutGroup.getStackRankPayouts().iterator();

                    while ( attachedPayoutIter.hasNext() )
                    {
                      StackRankPayout attachedPayout = (StackRankPayout)attachedPayoutIter.next();
                      // if ( detachedStackRankPayoutGroup.getStackRankPayouts().contains(
                      // attachedPayout ) )
                      // we can use above instead of the below method. But we had problem as
                      // contains returns false
                      // even though the attachedpayout object is presented in the detached group
                      // pay outs. May be
                      // it is because of failure in equals or hashcode mthods. That is why
                      // we had to iterate the the detached list and check for match.
                      if ( hashSetContains( detachedStackRankPayoutGroup.getStackRankPayouts(), attachedPayout ) )
                      {
                        if ( detachedPayout.getId().equals( attachedPayout.getId() ) )
                        {
                          attachedPayout.setStartRank( detachedPayout.getStartRank() );
                          attachedPayout.setEndRank( detachedPayout.getEndRank() );
                          attachedPayout.setPayout( detachedPayout.getPayout() );
                        }
                      }
                      else
                      {
                        attachedPayoutIter.remove();
                      }
                    } // end attached payouts iterator
                  }
                } // end detached payouts iterator
              }
            }
          } // end attached payout groups iterator
        }
      } // end detached payout groups iterator
    }
    else
    {
      attachedPromotion.getStackRankPayoutGroups().clear();
    }

    if ( attachedPromotion.getStackRankPayoutGroups() != null && attachedPromotion.getStackRankPayoutGroups().size() > 0 )
    {
      Iterator attachedGroupIterator = attachedPromotion.getStackRankPayoutGroups().iterator();
      while ( attachedGroupIterator.hasNext() )
      {
        StackRankPayoutGroup stackRankPayoutGroup = (StackRankPayoutGroup)attachedGroupIterator.next();
        // we can use below commented instead of the below method. But we had problem as contains
        // returns false
        // even though the attachedpayoutgroup object is presented in the detached groups. May be
        // it is because of failure in equals or hashcode mthods. That is why
        // we had to iterate the the detached list and check for match.
        // if ( !detachedPromotion.getStackRankPayoutGroups().contains( (
        // attachedGroupIterator.next() ) ) )
        if ( !hashSetContainsStackRankPayoutGroup( detachedPromotion.getStackRankPayoutGroups(), stackRankPayoutGroup ) )
        {
          attachedGroupIterator.remove();
        }
      }
    }
  }

  /**
   * Returns a true or false based on whether stackRankPayoutgroupss has
   * attachedStackRankPayoutgroup // if ( !detachedPromotion.getStackRankPayoutGroups().contains( (
   * attachedGroupIterator.next() ) ) ) //we can use above instead of the below method. But we had
   * problem as contains returns false //even though the attachedpayoutgroup object is presented in
   * the detached groups. May be //it is because of failure in equals or hashcode mthods. That is
   * why // we had to iterate the the detached list and check for match.
   * 
   * @return boolean
   */
  private boolean hashSetContainsStackRankPayoutGroup( Set stackRankPayoutGroups, StackRankPayoutGroup attachedStackRankPayoutGroup )
  {
    boolean contains = false;
    Iterator detachedGroupIterator = stackRankPayoutGroups.iterator();
    while ( detachedGroupIterator.hasNext() )
    {
      StackRankPayoutGroup detachedStackRankPayoutGroup = (StackRankPayoutGroup)detachedGroupIterator.next();
      if ( attachedStackRankPayoutGroup.getId().equals( detachedStackRankPayoutGroup.getId() ) )
      {
        contains = true;
        break;
      }
    }

    return contains;
  }

  /**
   * @param attachedPromotion
   */
  private void updateGoalQuestPromotion( GoalQuestPromotion attachedPromotion )
  {
    GoalQuestPromotion detachedPromotion = (GoalQuestPromotion)getDetachedDomain();

    attachedPromotion.setAchievementRule( detachedPromotion.getAchievementRule() );
    attachedPromotion.setPayoutStructure( detachedPromotion.getPayoutStructure() );
    attachedPromotion.setAchievementPrecision( detachedPromotion.getAchievementPrecision() );
    attachedPromotion.setRoundingMethod( detachedPromotion.getRoundingMethod() );
    attachedPromotion.setGoalPlanningWorksheet( detachedPromotion.getGoalPlanningWorksheet() );
    // BugFix 17935
    attachedPromotion.setBaseUnit( detachedPromotion.getBaseUnit() );
    attachedPromotion.setBaseUnitPosition( detachedPromotion.getBaseUnitPosition() );
    updateGoalLevels( detachedPromotion, attachedPromotion );
  }

  /**
   * 
   * Updates the goalLevels for the specified promotion.  This will update updated levels, add new levels, and remove deleted
   * levels.
   *  
   * @param detachedPromotion
   * @param attachedPromotion
   */
  private void updateGoalLevels( GoalQuestPromotion detachedPromotion, GoalQuestPromotion attachedPromotion )
  {
    Map updatedLevels = new TreeMap();
    Set detachedGoalLevels = detachedPromotion.getGoalLevels();
    Set attachedGoalLevels = attachedPromotion.getGoalLevels();
    boolean levelAdded = false;
    boolean levelRemoved = false;
    if ( detachedGoalLevels != null )
    {
      for ( Iterator detachedIter = detachedGoalLevels.iterator(); detachedIter.hasNext(); )
      {
        GoalLevel detachedGoalLevel = (GoalLevel)detachedIter.next();
        if ( detachedGoalLevel.getId() == null || detachedGoalLevel.getId().longValue() == 0 )
        {
          attachedPromotion.addGoalLevel( detachedGoalLevel );
          levelAdded = true;
        }
        else
        {
          updatedLevels.put( detachedGoalLevel.getId(), detachedGoalLevel );
        }
      }
    }
    for ( Iterator attachedIter = attachedGoalLevels.iterator(); attachedIter.hasNext(); )
    {
      GoalLevel attachedGoalLevel = (GoalLevel)attachedIter.next();
      if ( attachedGoalLevel.getId() != null && attachedGoalLevel.getId().longValue() != 0 )
      {
        GoalLevel detachedGoalLevel = (GoalLevel)updatedLevels.get( attachedGoalLevel.getId() );
        if ( detachedGoalLevel != null )
        {
          updateGoalLevel( detachedGoalLevel, attachedGoalLevel );
        }
        else
        {
          attachedIter.remove();
          levelRemoved = true;
        }
      }
    }
    // bug fix for 18580
    // removing all goals and setting it from scratch.(Because, hibernate will update the
    // collections by inserting the
    // items first and then delete it. So unique key constraint violation will occur since seq no,
    // promotionid ,
    // goallevel discriminator combination is unique. This is not needed when items are not deleted.
    if ( levelRemoved )
    {
      Set newAttachedGoalLevels = new HashSet( attachedPromotion.getGoalLevels() );
      attachedPromotion.getGoalLevels().clear();
      HibernateSessionManager.getSession().flush();
      // not setting the Set directly since dereferencing a collection when transtive persistence is
      // 'all-delete-orphan'
      // is not allowed in hibernate
      for ( Iterator i = newAttachedGoalLevels.iterator(); i.hasNext(); )
      {
        GoalLevel newGoalLevel = (GoalLevel)i.next();
        // set id to null since these are supposed to be new elements. This will avoid
        // StaleObjectStateException.
        newGoalLevel.setId( null );
        attachedPromotion.addGoalLevel( newGoalLevel );
      }
    }
    if ( ( levelAdded || levelRemoved ) && ( attachedPromotion.isLive() || attachedPromotion.isComplete() ) )
    {
      attachedPromotion.setPromotionStatus( PromotionStatusType.lookup( PromotionStatusType.UNDER_CONSTRUCTION ) );
    }
  }

  public void updateGoalLevel( GoalLevel detachedGoalLevel, GoalLevel attachedGoalLevel )
  {
    if ( detachedGoalLevel != null && attachedGoalLevel != null )
    {
      attachedGoalLevel.setSequenceNumber( detachedGoalLevel.getSequenceNumber() );
      attachedGoalLevel.setGoalLevelNameKey( detachedGoalLevel.getGoalLevelNameKey() );
      attachedGoalLevel.setGoalLevelDescriptionKey( detachedGoalLevel.getGoalLevelDescriptionKey() );
      attachedGoalLevel.setGoalLevelcmAssetCode( detachedGoalLevel.getGoalLevelcmAssetCode() );
      attachedGoalLevel.setAward( detachedGoalLevel.getAward() );
      attachedGoalLevel.setAchievementAmount( detachedGoalLevel.getAchievementAmount() );
      attachedGoalLevel.setMinimumQualifier( detachedGoalLevel.getMinimumQualifier() );
      attachedGoalLevel.setIncrementalQuantity( detachedGoalLevel.getIncrementalQuantity() );
      attachedGoalLevel.setMaximumPoints( detachedGoalLevel.getMaximumPoints() );
      attachedGoalLevel.setBonusAward( detachedGoalLevel.getBonusAward() );
      attachedGoalLevel.setManagerAward( detachedGoalLevel.getManagerAward() );
    }
  }

  /**
   * Returns a true or false based on whether stackRankPayouts has attachedStackRankPayout // if (
   * detachedStackRankPayoutGroup.getStackRankPayouts().contains( attachedPayout ) ) //we can use
   * above instead of the below method. But we had problem as contains returns false //even though
   * the attachedpayout object is presented in the detached group pay outs. May be //it is because
   * of failure in equals or hashcode mthods. That is why // we had to iterate the the detached list
   * and check for match.
   * 
   * @param stackRankPayouts
   * @param attachedStackRankPayout
   * @return boolean
   */
  private boolean hashSetContains( Set stackRankPayouts, StackRankPayout attachedStackRankPayout )
  {
    boolean contains = false;
    Iterator detachedGroupIterator = stackRankPayouts.iterator();
    while ( detachedGroupIterator.hasNext() )
    {
      StackRankPayout detachedPayout = (StackRankPayout)detachedGroupIterator.next();
      if ( attachedStackRankPayout.getId().equals( detachedPayout.getId() ) )
      {
        contains = true;
        break;
      }
    }

    return contains;
  }

  // ---------------------------------------------------------------------------
  // Private Methods--DAO Getter Methods
  // ---------------------------------------------------------------------------

  /**
   * Returns a reference to the Product DAO service.
   * 
   * @return a reference to the Product DAO service.
   */
  private ProductDAO getProductDAO()
  {
    return (ProductDAO)BeanLocator.getBean( ProductDAO.BEAN_NAME );
  }

  /**
   * Returns a reference to the NodeTypeDAO DAO service.
   * 
   * @return a reference to the NodeTypeDAO DAO service.
   */
  private NodeTypeDAO getNodeTypeDAO()
  {
    return (NodeTypeDAO)BeanLocator.getBean( NodeTypeDAO.BEAN_NAME );
  }

  /**
   * Returns a reference to the Product Category DAO service.
   * 
   * @return a reference to the Product Category DAO service.
   */
  private ProductCategoryDAO getProductCategoryDAO()
  {
    return (ProductCategoryDAO)BeanLocator.getBean( ProductCategoryDAO.BEAN_NAME );
  }

  /**
   * Returns a reference to the Promotion DAO service.
   * 
   * @return a reference to the Promotion DAO service.
   */
  private PromotionPayoutDAO getPromotionPayoutDAO()
  {
    return (PromotionPayoutDAO)BeanLocator.getBean( PromotionPayoutDAO.BEAN_NAME );
  }

  private ClaimFormDAO getClaimFormDAO()
  {
    return (ClaimFormDAO)BeanLocator.getBean( ClaimFormDAO.BEAN_NAME );
  }

}